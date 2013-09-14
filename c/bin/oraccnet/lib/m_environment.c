#include <stdlib.h>
#include <xmlrpc-c/base.h>
#include <xmlrpc-c/server.h>
#include <xmlrpc-c/server_cgi.h>

extern char **environ;

static xmlrpc_value *
environment_method(xmlrpc_env *const envP,
	     xmlrpc_value *const paramArrayP, 
	     void *serverInfo,
	     void *callInfo
	     )
{
  xmlrpc_value *arrayP;
  char **envp;
  arrayP = xmlrpc_array_new(envP);
  for (envp = environ; *envp; ++envp)
    xmlrpc_array_append_item(envP, arrayP, xmlrpc_string_new(envP, *envp));
  return arrayP;
}

struct xmlrpc_method_info3 m3_environment_info =
{
  "environment",
  environment_method,
  NULL,
  0,
  "s:",
  "return all environment variables and their values",
};
