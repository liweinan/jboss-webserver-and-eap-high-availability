# How To Use Tomcat Vault

Tomcat Vault is a tool that allows you to encrypt the passwords in Apache Tomcat configuration files.

For example, here is one line excerpted from "tomcat-users.xml":

```xml
<user username="tomcat" password="tomcat" roles="tomcat"/>
```

As we can see above, the password is stored as plaintext and it's a security risk. Though the configuration in store on server, it's still very dangerous to store password in such way.

Tomcat Vault is created to solve this problem, it will encrypt your password and store it in standard Java keystore, and let tomcat access the password in a safe way.

In this article, I'd like to show you how to use it with Tomcat.



