# How To Use Apache Commons Daemon

Apache Commons Daemon is a tool provided by Apache community which can help you to manage your Java application(usually a server) as a standard system daemon.

The Apache Commons Daemon consists of two parts: One part is written in Java called `commons-daemon`, the other part is called `jsvc` which is written in C.

The `commons-daemon` part gives you some Java interfaces that you should follow to wrap your server program. The most important interface you need to implement is `Daemon.java`:

```java
public interface Daemon
{

    /**
     * Initializes this <code>Daemon</code> instance.
     * <p>
     *   This method gets called once the JVM process is created and the
     *   <code>Daemon</code> instance is created thru its empty public
     *   constructor.
     * </p>
     * <p>
     *   Under certain operating systems (typically Unix based operating
     *   systems) and if the native invocation framework is configured to do
     *   so, this method might be called with <i>super-user</i> privileges.
     * </p>
     * <p>
     *   For example, it might be wise to create <code>ServerSocket</code>
     *   instances within the scope of this method, and perform all operations
     *   requiring <i>super-user</i> privileges in the underlying operating
     *   system.
     * </p>
     * <p>
     *   Apart from set up and allocation of native resources, this method
     *   must not start the actual operation of the <code>Daemon</code> (such
     *   as starting threads calling the <code>ServerSocket.accept()</code>
     *   method) as this would impose some serious security hazards. The
     *   start of operation must be performed in the <code>start()</code>
     *   method.
     * </p>
     *
     * @param context A <code>DaemonContext</code> object used to
     * communicate with the container.
     * @exception DaemonInitException An exception that prevented
     * initialization where you want to display a nice message to the user,
     * rather than a stack trace.
     * @exception Exception Any exception preventing a successful
     *                      initialization.
     */
    public void init(DaemonContext context)
        throws DaemonInitException, Exception;

    /**
     * Starts the operation of this <code>Daemon</code> instance. This
     * method is to be invoked by the environment after the init()
     * method has been successfully invoked and possibly the security
     * level of the JVM has been dropped. Implementors of this
     * method are free to start any number of threads, but need to
     * return control after having done that to enable invocation of
     * the stop()-method.
     */
    public void start()
        throws Exception;

    /**
     * Stops the operation of this <code>Daemon</code> instance. Note
     * that the proper place to free any allocated resources such as
     * sockets or file descriptors is in the destroy method, as the
     * container may restart the Daemon by calling start() after
     * stop().
     */
    public void stop()
        throws Exception;

    /**
     * Frees any resources allocated by this daemon such as file
     * descriptors or sockets. This method gets called by the container
     * after stop() has been called, before the JVM exits. The Daemon
     * can not be restarted after this method has been called without a
     * new call to the init() method.
     */
    public void destroy();
}
```

From the above interface we can see there are several methods related with a server cycle you should implement. How does `commons-daemon` uses the above interface to manage your Java application? The answers lies in `jsvc` part. `jsvc` is written in C, and it provides you three processes[^1], which are called the `Launcher Process`, the `Controller Process`, and the `Controlled Process`.

The purpose of the launcher process is very straight-forward, which will launch a child process. The child process will be a Java instance and it's called the `controller process`.

The controller process will start JVM and start your Java application by properly calling the `init` and `start` methods defined in above interface. Then it will wait for standard Linux/UNIX process signals. So afterthen you can send standard Linux/UNIX signals to stop your Java application, and this process will call `stop` and `destroy` methods according to the signal you send to this process.

The started Java application process is called the `controlled process`, it's your Java application that is running. This process is downgraded to normal user privileges by using system capabilities like `setuid` and `setgid` or so.

How can `jsvc` start JVM? It uses `JNI` to interact with Java Virtual Machine. The fullname of `JNI` is called `Java Native Interface`[^2], and it is a stanard framework to enables Java code running in a Java Virtual Machine (JVM) to call and be called by native applications. You don't have to understand the details of `jsvc`, but if you are interested in the implementation, you can see the usage of `JNI_CreateJavaVM()` method provided by Java in `jsvc` source code as a start point to learn about `jsvc`. In general, the purpose of the `jsvc` is to manage the lifecycle of your Java application by interacting with `Daemon` interface on Java side, and you get the ability to start/stop your Java application by using standard system signals scheme.

[^1]: https://commons.apache.org/proper/commons-daemon/jsvc.html
[^2]: https://en.wikipedia.org/wiki/Java_Native_Interface
