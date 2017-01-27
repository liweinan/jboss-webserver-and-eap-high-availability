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

As we have understood the meaning of this simple module, now we can compile it. `Apache HTTPD` has provided a module compiling and installing tool for us called `apxs`:

![](imgs/httpd_module_02.jpeg)

We can use it to compile our `foo_module`:

![](imgs/httpd_module_03.jpeg)

As the snapshot shown above，we have used `apxs` to compile `foo_module.c`:

```bash
$ apxs -a -c foo_module.c
```

The output of compling process is like this:

```bash
/usr/lib64/apr-1/build/libtool --silent --mode=compile gcc -prefer-pic -O2 -g -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic  -DLINUX -D_REENTRANT -D_GNU_SOURCE -pthread -I/usr/include/httpd  -I/usr/include/apr-1   -I/usr/include/apr-1   -c -o foo_module.lo foo_module.c && touch foo_module.slo
/usr/lib64/apr-1/build/libtool --silent --mode=link gcc -Wl,-z,relro,-z,now   -o foo_module.la  -rpath /usr/lib64/httpd/modules -module -avoid-version    foo_module.lo
```

As the output shown above, we can see `apxs` used `libtool` to compile our module, and generated many files:

```bash
$ ls
foo_module.c  foo_module.la  foo_module.lo  foo_module.o  foo_module.slo
```

There are also generated files in `.libs` directory：

```bash
$ ls -l ./.libs/
total 104
-rw-rw-r--. 1 weli weli 35580 Jan 27 02:55 foo_module.a
lrwxrwxrwx. 1 weli weli    16 Jan 27 02:55 foo_module.la -> ../foo_module.la
-rw-rw-r--. 1 weli weli   938 Jan 27 02:55 foo_module.lai
-rw-rw-r--. 1 weli weli 35432 Jan 27 02:55 foo_module.o
-rwxrwxr-x. 1 weli weli 25560 Jan 27 02:55 foo_module.so
```



