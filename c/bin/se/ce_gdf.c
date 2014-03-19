#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <ctype128.h>
#include <psdtypes.h>
#include <hash.h>
#include <messages.h>
#include <npool.h>
#include <gdf.h>
#include <xmlutil.h>
#include <xpd2.h>
#include "ce.h"
#include "p2.h"

#ifndef _MAX_PATH
#define _MAX_PATH 1024
#endif

static int nfields = 0, nwidths = 0;

extern int p3;

extern int item_offset, tabbed;
extern const char *arg_fields;
extern const char *gdfset, *mode, *project;
const char *gdf_fields = NULL, *gdf_widths = NULL;

static const char **field_specs;
static const char **width_specs;

static struct npool *ce_gdf_pool;

static List **field_lists;

static List *record_hashes;
static struct npool *record_pool;
static Hash_table *curr_record_hash = NULL;

char *url_base = NULL;

int
gdf_field_count(void)
{
  return nfields;
}

static int
count_entries(const char *tmp, const char *option)
{
  int i;
  for (i = 1; *tmp; ++tmp)
    {
      if (',' == *tmp)
	{
	  ++i;
	  while (isspace(tmp[1]))
	    ++tmp;
	  if (',' == tmp[1])
	    {
	      fprintf(stderr, "ce_gdf: %s/gdf.xml: empty field in `%s'\n",
		      gdfset, option);
	      while (isspace(tmp[1]) || ',' == tmp[1])
		++tmp;
	    }
	}
    }
  return i;
}

static void
set_entries(const char **entries, const char *option)
{
  int i;
  char *tmp;

  tmp = malloc(strlen(option)+1);
  (void)strcpy(tmp, option);
  for (i = 0, entries[0] = tmp; *tmp; )
    {
      if (',' == *tmp)
	{
	  *tmp++ = '\0';
	  while (isspace(tmp[1]))
	    ++tmp;
	  if (',' == tmp[1])
	    {
	      fprintf(stderr, "ce_gdf: %s/gdf.xml: empty field in `%s'\n",
		      gdfset, option);
	      while (isspace(tmp[1]) || ',' == tmp[1])
		++tmp;
	    }
	  if (*tmp)
	    entries[++i] = tmp;
	}
      else
	++tmp;
    }
  entries[++i] = NULL;
}

static void
set_field_lists(const char **fieldspecs)
{
  int i;
  vec_sep_str = "|";
  field_lists = malloc((1+nfields) * sizeof(List *));
  for (i = 0; fieldspecs[i]; ++i)
    {
      char *str = malloc(strlen(fieldspecs[i])+1);
      strcpy(str, fieldspecs[i]);
      field_lists[i] = list_from_str(str, NULL, LIST_SINGLE);
      free(str);
    }
  field_lists[i] = 0;
}

int
gdfinit2(const char *project)
{
  struct p2_options *p2opt = NULL;

  ce_gdf_pool = npool_init();
  gdfinfo = gdf_xml_load(gdfxml, ce_gdf_pool);

  nfields = count_entries(gdfinfo->fields, "catalog-fields");
  nwidths = count_entries(gdfinfo->widths, "catalog-widths");

  if (nfields != nwidths)
    {
      fprintf(stderr, 
	      "ce_gdf: %s/gdf.xml: `%s-catalog-fields' and `%s-catalog-widths' should have same number of entries\n",
	      project, state, state);
      return 1;
    }

  field_specs = malloc((nfields+1)*sizeof(const char *));
  width_specs = malloc((nwidths+1)*sizeof(const char *));

  set_entries(field_specs, gdf_fields);
  set_entries(width_specs, gdf_widths);

  set_field_lists(field_specs);

  record_hashes = list_create(LIST_SINGLE);
  record_pool = npool_init();

  return 0;
}

static int
alldigit(const char *s)
{
  while (isdigit(*s))
    ++s;
  return (*s == '\0');
}

void
gdf_sH(void *userData, const char *name, const char **atts)
{
  if (!strcmp(name,"gdf:entry"))
    {
      const char *id = attr_by_name(atts,idattr);
      if (id && (idcountp = hash_find(ht,(const unsigned char*)id)))
	{
	  curr_record_hash = hash_create(1);
	  hash_add(curr_record_hash, "xmlid", npool_add(id, record_pool));
	}
      echoing = 1;
    }
  else if (echoing)
    {
      if (echoing++ > 1)
	fprintf(stderr, "ce_gdf: GDF records may not contain XML tags\n");
    }
  else
    charData_discard();
}

void
gdf_eH(void *userData, const char *name)
{
  if (!strcmp(name,cfg.tag))
    {
      echoing = 0;
      list_add(record_hashes, curr_record_hash);
      curr_record_hash = NULL;
      charData_discard();
    }
  else if (echoing)
    {
      if (--echoing == 1)
	{
	  hash_add(curr_record_hash, 
		   npool_add(name, record_pool), 
		   npool_add(name, charData_retrieve()));
	}
    }
  else
    charData_discard();
}

void
gdfprinter(void)
{
  list_exec(record_hashes, (void(*)(void*))gdfprinter2);
}

/* Previous version had this:

   Hack designation/primary_publication issues: if 0 is empty, use 1;
     if 0 == 1, empty 1 
  if (!strcmp(print_ptrs[0]," "))
    {
      print_ptrs[0] = print_ptrs[1];
      print_ptrs[1] = " ";
    }
  else if (!strcmp(print_ptrs[0], print_ptrs[1]))
    print_ptrs[1] = " ";
 */
void
gdfprinter2(Hash_table *fields)
{
  static int nth = 0;
  int i;
  const char *designation = NULL;
  const char *icon = NULL, *icon_alt;
  const char *id = NULL;

  ++nth;
  if (!url_base)
    url_base = malloc(strlen(project) + strlen("javascript:p3item('cat',)")+8);
  sprintf(url_base, "javascript:p3item('cat',%d)", item_offset+nth);
  
  fputs("<ce:data><tr xmlns=\"http://www.w3.org/1999/xhtml\">",stdout);

  if ((id = hash_find(fields, (unsigned char *)"id_text")))
    {
      if (*id == 'P')
	{
	  icon = "cdli-icon.png";
	  /* url_base = "http://oracc.museum.upenn.edu/%s/cat"; */
	  /* url_base = "http://cdli.ucla.edu"; */
	  icon_alt = "CDLI catalog";
	}
      else
	{
	  static char projurl[128];
	  icon = "xnum-icon.png";
	  sprintf(projurl, "/%s", project);
	  /* url_base = "http://oracc.museum.upenn.edu/cat"; */
	  icon_alt = "project catalog";
	}
    }
  else if ((id = hash_find(fields, (unsigned char *)"id_composite")))
    {
      icon = "Qcat-icon.png";
      /* url_base = "http://oracc.museum.upenn.edu/cat"; */
      icon_alt = "Q catalog";
    }
  fprintf(stdout, "<td class=\"ce-gdf-icon\"><a href=\"%s\"><img src=\"/img/%s\" alt=\"%s in %s\"/></a></td>", url_base, icon, id, icon_alt);
  for (i = 0; width_specs[i]; ++i)
    {
      List *tmp = field_lists[i];
      const char *pct = width_specs[i];
      const char *field, *value, *field_used = "";
      char pctbuf[4];
      int this_is_designation = 0;

      for (field = list_first(tmp); field; field = list_next(tmp))
	{
	  if ((value = hash_find(fields, (unsigned char *)field)))
	    {
	      field_used = field;
	      break;
	    }
	}
      if (!strcmp(field_used, "designation"))
	{
	  designation = value;
	  this_is_designation = 1;
	}
      if (!value || !strlen(value)
	  || (designation 
	      && !strcmp(field_used, "primary_publication")
	      && !strcmp(designation, value)))
	value = " ";
      if (alldigit(pct))
	{
	  strncpy(pctbuf,pct,2);
	  pctbuf[2] = '%';
	  pctbuf[3] = '\0';
	  pct = pctbuf;
	}
      if (p3)
	{
	  if (this_is_designation || i < link_fields)
	    fprintf(stdout, "<td style=\"width: %s\"><a href=\"javascript:p3item('xtf',%d)\">%s</a></td>", pct, item_offset+nth, xmlify(value));
	  else
	    fprintf(stdout, "<td style=\"width: %s;\">%s</td>", pct, xmlify(value));
	}
      else
	{
	  if (this_is_designation || i < link_fields)
	    fprintf(stdout, "<td style=\"width: %s\"><a href=\"javascript:itemView(%d)\">%s</a></td>", pct, item_offset+nth, xmlify(value));
	  else
	    fprintf(stdout, "<td style=\"width: %s;\">%s</td>", pct, xmlify(value));
	}
    }
  fputs("</tr></ce:data>",stdout);
}
