# Write An Apache HTTPD Module

In this article I'd like to show you how to write a module for `Apache HTTPD`. I'm using `Fedora Linux`, So I can use the `httpd` and `httpd-devel` provided by system:

![](imgs/httpd_module_01.jpeg)

The reason to install `httpd-devel` is that we need the header files relative to module deveplopment provided by it. Now let's write a simple module:

```c
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
```

This module will use `AP_MODULE_DECLARE_DATA` to register a `foo_module`：

```c
module AP_MODULE_DECLARE_DATA foo_module = ...
```

And it will use `foo_hooks` to call `ap_hook_handler`, and `ap_hook_handler` will load our `foo_handler` into `httpd`：

```c
static void foo_hooks(apr_pool_t *pool) {
  ap_hook_handler(foo_handler, NULL, NULL, APR_HOOK_MIDDLE);
}
```

Our main function `foo_handler` is very simple. You can see it doesn't deal with `request_rec`. It will just output some HTML data：

```c
ap_set_content_type(r, "text/html");
ap_rprintf(r, "Hello, martian!");
```

As we have understood the meaning of this simple module, now we can compile it.
