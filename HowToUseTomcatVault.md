# How To Use Tomcat Vault

Tomcat Vault is a tool that allows you to encrypt the passwords in Apache Tomcat configuration files.

For example, here is one line excerpted from "tomcat-users.xml":

```xml
<user username="tomcat" password="tomcat" roles="tomcat"/>
```

As we can see above, the password is stored as plaintext and it's a security risk. Though the configuration in store on server, it's still very dangerous to store password in such way.

Tomcat Vault is created to solve this problem, it will encrypt your password and store it in standard Java keystore, and let tomcat access the password in a safe way. In this article, I'd like to show you how to use it with Tomcat.

## Installation of Apache Tomcat and Tomcat-Vault

First we need to have [Apache Tomcat](http://tomcat.apache.org/) and [Tomcat-Vault](https://github.com/picketbox/tomcat-vault) installed on our machine.

For Tomcat, I am using 8.0.39 for this article.

For Tomcat Vault, I just clone the project from GitHub into my local machine and build it from master branch:

```bash
git clone https://github.com/picketbox/tomcat-vault.git
```

And then using Maven to build and install it:

```bash
tb13:tomcat-vault weli$ pwd
/Users/weli/projs/tomcat-vault
tb13:tomcat-vault weli$ mvn install
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] Building Vault extension for Apache Tomcat 1.0.8.Final
[INFO] ------------------------------------------------------------------------
[INFO]
...
copy dependency file to the correct module directory:
     [copy] Copying 1 file to /Users/weli/projs/tomcat-vault/modules/system/layers/base/tomcat-vault/main
[INFO] Executed tasks
[INFO]
[INFO] --- maven-install-plugin:2.4:install (default-install) @ tomcat-vault ---
[INFO] Installing /Users/weli/projs/tomcat-vault/target/tomcat-vault-1.0.8.Final.jar to /Users/weli/.m2/repository/org/apache/tomcat/tomcat-vault/1.0.8.Final/tomcat-vault-1.0.8.Final.jar
[INFO] Installing /Users/weli/projs/tomcat-vault/pom.xml to /Users/weli/.m2/repository/org/apache/tomcat/tomcat-vault/1.0.8.Final/tomcat-vault-1.0.8.Final.pom
[INFO] Installing /Users/weli/projs/tomcat-vault/target/tomcat-vault-1.0.8.Final-jar-with-dependencies.jar to /Users/weli/.m2/repository/org/apache/tomcat/tomcat-vault/1.0.8.Final/tomcat-vault-1.0.8.Final-jar-with-dependencies.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 2.567 s
[INFO] Finished at: 2016-12-20T16:34:53+08:00
[INFO] Final Memory: 17M/265M
[INFO] ------------------------------------------------------------------------
```

After building it, we can get the tomcat-vault jars:

```bash
tb13:tomcat-vault weli$ ls -1 target/*.jar
target/tomcat-vault-1.0.8.Final-jar-with-dependencies.jar
target/tomcat-vault-1.0.8.Final.jar
```

Next we will can try to play with 'tomcat-vault-1.0.8.Final-jar-with-dependencies.jar' to see if it can work correctly.

First we should make sure that we are in the 'target' directory which contains the generated jar files:

```bash
tb13:target weli$ pwd
/Users/weli/projs/tomcat-vault/target
tb13:target weli$ ls *.jar
tomcat-vault-1.0.8.Final-jar-with-dependencies.jar tomcat-vault-1.0.8.Final.jar
```

Because the jar file contains a Main class, so we can invoke it like this:

```bash
tb13:target weli$ java -classpath tomcat-vault-1.0.8.Final-jar-with-dependencies.jar org.apache.tomcat.vault.VaultTool
**********************************
****  JBoss Vault  ***************
**********************************
Please enter a Digit::   0: Start Interactive Session  1: Remove Interactive Session  2: Exit
```

If everything goes fine, you can directly using the _java_ command as shown above to start the _org.apache.tomcat.vault.VaultTool_.

The next step is to put tomcat-vault jar into our local Apache Tomcat directory:

```bash
tb13:lib weli$ pwd
/Users/weli/projs/apache-tomcat-8.0.39/lib
tb13:lib weli$ cp ~/projs/tomcat-vault/target/tomcat-vault-1.0.8.Final-jar-with-dependencies.jar .
```

As the command shown above, we have the tomcat-vault jar with dependecies copied into tomcat lib directory.

Till now, the installation step is finished, and next we can start to integrate tomcat-vault with tomcat.

## Generating Java Keystore for Tomcat Vault


Tomcat Vault relies on Java Keystore to store the passwords, so the first step is to use _keytool_ command provided by JDK to generate a keystore.

Here is the command to generate keystore:

```bash
tb13:conf weli$ keytool -genseckey -keystore vault.keystore -alias my_vault -storetype jceks -keyalg AES -keysize 128 -storepass my_password123 -keypass my_password123 -validity 730
```

As the command shown above, we have generated a keystore named _vault.keystore_, and set the password of the store to _my\_password123_. We also set the password of the generated key pair to _my\_password123_.


Please note that I have put the above generated keystore file to _conf_ directory of Tomcat:

```bash
tb13:conf weli$ pwd
/Users/weli/projs/apache-tomcat-8.0.39/conf
tb13:conf weli$ ls vault.keystore
vault.keystore
```
