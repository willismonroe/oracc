#include <stdio.h>
#include "runexpat.h"
#include "hash.h"
#include "list.h"
#include "npool.h"
#include "props.h"

/* This needs to be refactored as part of an XVL library */

struct prop_context
{
  Hash_table *names;
  struct npool *pool;
};

static struct prop_context *pc = NULL;

static void
ap_sH(void *userData, const char *name, const char **atts)
{
  if (!strcmp(name,"property"))
    {
      const char *name = findAttr(atts, "name");
      if (name)
	{
	  if (!hash_find(pc->names, (unsigned char *)name))
	    {
	      struct propdef *pd = calloc(1,sizeof(struct propdef));
	      const char *type = findAttr(atts,"type");
	      pd->name = (unsigned char*)npool_copy((unsigned char*)name,pc->pool);
	      pd->group = npool_copy((unsigned char*)findAttr(atts,"group"),pc->pool);
	      if (*(findAttr(atts,"multi")))
		pd->multi = 1;
	      if (!strcmp(type,"flag"))
		pd->type = pd_type_flag;
	      else if (!strcmp(type,"ref"))
		pd->type = pd_type_ref;
	      else if (!strcmp(type,"string"))
		pd->type = pd_type_string;
	      else if (!strcmp(type,"token"))
		pd->type = pd_type_token;
	      else
		fprintf(stderr,"props: bad type `%s'\n", type);
	      hash_add(pc->names, pd->name, pd);
	    }
	  else
	    {
	      fprintf(stderr,"props: double definition for prop `%s'\n",name);
	    }
	}
   }
  else if (!strcmp(name,"declaration"))
    {
    }
}

static void
ap_eH(void *userData, const char *name)
{
}

void
props_auto_init(void)
{
  const char *fnlist[2];
  const char *prop_data = "@@ORACC@@/lib/data/props-qpn.xml";

  pc = malloc(sizeof(struct prop_context));
  pc->names = hash_create(10);
  pc->pool = npool_init();
  
  if (!access(prop_data, R_OK))
    {
      fnlist[0] = prop_data;
      fnlist[1] = NULL;
      runexpat(i_list, fnlist, ap_sH, ap_eH);
    }
  else
    {
      fprintf(stderr,"ox: props data not found (`%s')\n",prop_data);
    }
}

static void
names_free(struct propdef *pd)
{
  free(pd);
}

void
props_auto_term(void)
{
  if (pc)
    {
      hash_free(pc->names, (hash_free_func*)names_free);
      npool_term(pc->pool);
      free(pc);
      pc = NULL;
    }
}

struct propdef *
props_auto_name(const unsigned char *name)
{
  return hash_find(pc->names, name);
}
