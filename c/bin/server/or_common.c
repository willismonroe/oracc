#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "resolver.h"

const char *
cgi_arg(const char *arg, const char *val)
{
  char *c = malloc(strlen(arg)+strlen(val)+2);
  sprintf(c, "%s=%s", arg, val);
  return c;
}

void
do400(const char *message)
{
  puts("HTTP/1.1 400 Bad Request\n");
  puts(message);
  exit(0);
}

void
do404(void)
{
  print_hdr();
  execl("/bin/cat", "cat", "/Users/stinney/orc/www/404.html", NULL);
}

const char *
oracc_home ()
{
  static char *cached_home = NULL;
  if (NULL == cached_home)
    {
      cached_home = getenv ("ORACC");
      if (NULL == cached_home)
	cached_home = "/Users/stinney/orc";
    }
  return cached_home;
}

const char *
oracc_var ()
{
  static char *cached_var = NULL;
  if (NULL == cached_var)
    {
      cached_var = getenv ("ORACC_VAR");
      if (NULL == cached_var)
	cached_var = "/Users/stinney/orc";
    }
  return cached_var;
}

char *
or_find_www_file(const char *project, const char *dir, const char *basename, const char *ext)
{
  char *bufp = NULL;
  if (!project || !basename)
    return NULL;
  if (!dir)
    dir = "";
  if (!ext)
    ext = "";
  bufp = malloc(strlen(docroot) + strlen(project) + strlen(dir) + 
		strlen(basename) + strlen(ext) + strlen("////") + 1);
  sprintf(bufp,"%s/%s%s%s/%s%s%s",
	  docroot,project,
	  (*dir ? "/" : ""), dir,
	  basename,
	  (*ext ? "." : ""), ext);
  return bufp;
}

char *
or_find_pqx_file(const char *project, const char *pqid, const char *ext)
{
  char prefix[5], *bufp, pqx[8], *colon, *xproject = NULL;
  if (!project || !pqid || !ext)
    return NULL;

  if ((colon = strchr(pqid, ':')))
    {
      strcpy(pqx, colon+1);
      xproject = malloc(1+(colon-pqid));
      strncpy(xproject,pqid,colon-pqid);
      xproject[colon-pqid] = '\0';
    }
  else
    {
      xproject = (char*)project;
      strcpy(pqx, pqid);
    }
  

  if (!strcmp(ext, "tei"))
    {
      bufp = malloc((3 * strlen(pqx)) + strlen(xproject) + 6);
      sprintf(bufp,"%s/%s/00tei/%s.xml",xmlroot,xproject,pqx);
    }
  else
    {
      strncpy(prefix,pqx,4);
      prefix[4] = '\0';
      bufp = malloc(strlen(oracc_home()) + (4 * strlen(pqx)) + strlen(xproject) + 7);
      sprintf(bufp,"%s/bld/%s/%s/%s/%s.%s",oracc_home(),xproject,prefix,pqx,pqx,ext);
    }
  return bufp;
}

char *
or_find_pqx_xtr(const char *project, const char *pqid, const char *code, const char *lang)
{
  char prefix[5], *bufp, pqx[8], *colon, *xproject = NULL;
  if (!project || !pqid || !code || !lang)
    return NULL;

  if ((colon = strchr(pqid, ':')))
    {
      strcpy(pqx, colon+1);
      xproject = malloc(1+(colon-pqid));
      strncpy(xproject,pqid,colon-pqid);
      xproject[colon-pqid] = '\0';
    }
  else
    {
      xproject = (char*)project;
      strcpy(pqx, pqid);
    }  

  strncpy(prefix,pqid,4);
  prefix[4] = '\0';
  bufp = malloc((4 * strlen(pqx)) + strlen(xproject) + strlen(code) + strlen(lang) + 10);
  sprintf(bufp,"%s/bld/%s/%s/%s/%s_%s-%s.xtr",oracc_home(),xproject,prefix,pqx,pqx,code,lang);
  return bufp;
}

void
print_hdr(void)
{
  fputs("Content-type: text/html; charset=utf-8\n\n", stdout);
  fflush(stdout);
}

void
print_hdr_text(void)
{
  fputs("Content-type: text/plain; charset=utf-8\n\n", stdout);
  fflush(stdout);
}

void
print_hdr_xml(void)
{
  fputs("Content-type: text/xml; charset=utf-8\n\n", stdout);
  fflush(stdout);
}

void
print_hdr_json()
{
  fprintf(stdout,
	  "Content-type: application/json\n\n");
  fflush(stdout);
}

void
print_hdr_zip(const char *zname)
{
  fprintf(stdout,
	  "Content-type: application/zip\nContent-disposition: attachment; filename=\"%s\"\n\n", zname);
  fflush(stdout);
}

void
print_xforms_pi(void)
{
  puts("<?xml-stylesheet href=\"/xsltforms/xsltforms.xsl\" type=\"text/xsl\"?>");
  fflush(stdout);
}
