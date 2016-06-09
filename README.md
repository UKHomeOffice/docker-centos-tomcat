# tomcat

## Description
Apache Tomcat Container

## Usage

To build this container you need to run:

```
make build
```

If you want TLS configured then you need to put your ca.crt, crt.pem and key.pem into the ssl directory for these to be mounted into the image (with those specific names). If you would like to enable Basic Auth as well then you need to rename and edit ssl/tomcat-users.xml.template to ssl/tomcat-user.xml adding any users as required. The SSL directory should then be mounted into the container to /opt/tomcat/ssl. To run the Tomcat container run which will dynamically start with SSL/Basic Auth if it finds the correct files:

```
make run
```

This will startup a Tomcat container running Catalina


## Tests

As part of the build process the docker file will run the OpenSSL and Tomcat test exiting and failing the build if these fail.


### Credits

This package was created with Cookiecutter_ and the `audreyr/cookiecutter-pypackage`_ project template.

[Cookiecutter](https://github.com/audreyr/cookiecutter)
[audreyr/cookiecutter-pypackage](https://github.com/audreyr/cookiecutter-pypackage)
