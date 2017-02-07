// module_foo.c
#include <stdio.h>
#include "apr_hash.h"
#include "ap_config.h"
#include "ap_provider.h"
#include "httpd.h"
#include "http_core.h"
#include "http_config.h"
#include "http_log.h"
#include "http_protocol.h"
#include "http_request.h"


static int foo_handler(request_rec *r) {
  if (!r->handler || strcmp(r->handler, "foo_handler")) return (DECLINED);

  ap_set_content_type(r, "text/html");
  ap_rprintf(r, "Hello, martian!");

  return OK;
}

static void foo_hooks(apr_pool_t *pool) {
  ap_hook_handler(foo_handler, NULL, NULL, APR_HOOK_MIDDLE);
}

module AP_MODULE_DECLARE_DATA foo_module = {
  STANDARD20_MODULE_STUFF,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
        foo_hooks
};
