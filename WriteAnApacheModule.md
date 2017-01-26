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

这个模块通过`AP_MODULE_DECLARE_DATA`来注册一个`foo_module`：

```c
module AP_MODULE_DECLARE_DATA foo_module = {
```

并会在运行时通过`foo_hooks`中调用`ap_hook_handler`将我们的逻辑函数`foo_handler`注册进httpd：

```c
static void foo_hooks(apr_pool_t *pool) {
  ap_hook_handler(foo_handler, NULL, NULL, APR_HOOK_MIDDLE);
}
```

我们的`foo_handler`功能非常简单，并不处理用户请求`request_rec`，只是先判断在`httpd.conf`中模块是否设置为`{foo_handler}`。判断完成后，这个模块会直接返回`HTML`数据：

```c
  ap_set_content_type(r, "text/html");
  ap_rprintf(r, "Hello, martian!");
```

理解了这个module的作用以后，接下来是编译这个module。
