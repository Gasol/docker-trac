# Trac

> https://en.wikipedia.org/wiki/Trac

An open-source, Web-based project management and bug tracking system.

## Available tags

- [`1.2-alpine3.10`, `1.2.5-alpine3.10`](https://github.com/Gasol/docker-trac/blob/master/1.2/alpine3.10/Dockerfile)
- [`1.4-alpine3.10`](https://github.com/Gasol/docker-trac/blob/master/1.4/alpine3.10/Dockerfile)

## How to use this image

Assumed you had a Trac environment folder named 'demo' in your current working directory, You can simply run by following command:

    $ docker run -d -v $PWD:/trac gasolwu/trac:1.2

The Trac standalone server will run on port 80 by default.

If you haven't own the Trac environment, You can create one by command `initenv`:

    $ docker run -u $(id -u) -v $PWD:/trac gasolwu/trac:1.2 initenv demo
    $ tree -C demo/
    demo/
    ├── conf
    │   ├── trac.ini
    │   └── trac.ini.sample
    ├── db
    │   └── trac.db
    ├── htdocs
    ├── log
    │   └── trac.log
    ├── plugins
    ├── README
    ├── templates
    │   ├── site_footer.html.sample
    │   ├── site_header.html.sample
    │   └── site_head.html.sample
    └── VERSION

## Entrypoint

> docker run gasolwu/trac [COMMAND] [ARGS]

If the command doesn't match the special commands as described below, It is treated as arguments for `tracd`. If no argument provides, The default arguments of the entrypoint are `--port=80 --env-parent-dir=/trac`.

Here is full of help message.

    $ docker run --rm gasolwu/trac:1.2 --help
    Options:
      --version             show program's version number and exit
      -h, --help            show this help message and exit
      -a DIGESTAUTH, --auth=DIGESTAUTH
                            [projectdir],[htdigest_file],[realm]
      --basic-auth=BASICAUTH
                            [projectdir],[htpasswd_file],[realm]
      -p PORT, --port=PORT  the port number to bind to
      -b HOSTNAME, --hostname=HOSTNAME
                            the host name or IP address to bind to
      --protocol=PROTOCOL   http|scgi|ajp|fcgi
      -q, --unquote         unquote PATH_INFO (may be needed when using ajp)
      --http10              use HTTP/1.0 protocol version instead of HTTP/1.1
      --http11              use HTTP/1.1 protocol version (default)
      -e PARENTDIR, --env-parent-dir=PARENTDIR
                            parent directory of the project environments
      --base-path=BASE_PATH
                            the initial portion of the request URL's "path"
      -r, --auto-reload     restart automatically when sources are modified
      -s, --single-env      only serve a single project without the project list
      -d, --daemonize       run in the background as a daemon
      --pidfile=PIDFILE     when daemonizing, file to which to write pid
      --umask=MASK          when daemonizing, file mode creation mask to use, in
                            octal notation (default 022)
      --group=GROUP         the group to run as
      --user=USER           the user to run as

- `admin` - Synonym for trac-admin
- `initenv` - Lazy version of original `initenv`,

    It's minimum requirement for initialization, The default user with admin rights is set to `admin` and password is `s3cret`, They can be changed by environment variables `TRAC_ADMIN` and `TRAC_ADMIN_PASSWORD`, and the default database is SQLite.

## How to install Trac plugins

You can extend this image to install 3rd-party plugins for customization, or, Connect to the running container by `docker exec` and install plugins on attached shell for the purpose of testing.

This image provides another way for that, You must list the plugins you want to install in an file, This file is best known as `requirements.txt` in general, Put the file in a directory which should be mount as docker volume, and then tell the image where it is via `PIP_REQUIREMENTS_FILE` environment variable.

Example for XmlRpcPlugin installation:

    $ cat > requirements.txt <<EOF
    TracXMLRPC==1.1.8
    EOF
    $ docker run -it --rm -e PIP_REQUIREMENTS_FILE=/trac/requirements.txt -v $PWD:/trac gasolwu/trac:1.2 admin /trac/demo
    Collecting TracXMLRPC==1.1.8
      Downloading https://files.pythonhosted.org/packages/6c/5e/a2c44df9fa167a01aa787417a048840234a77c1d5401e86ef601465ee4eb/TracXMLRPC-1.1.8-py2-none-any.whl
    Installing collected packages: TracXMLRPC
    Successfully installed TracXMLRPC-1.1.8
    Welcome to trac-admin 1.2.5
    Interactive Trac administration console.
    Copyright (C) 2003-2019 Edgewall Software
    
    Type:  '?' or 'help' for help on commands.
    
    Trac [/trac/demo]> config set components tracrpc.* enabled
    Trac [/trac/demo]> permission add authenticated XML_RPC
    Trac [/trac/demo]> ^D

# License

The build scripts in this repository is licensed under the [MIT](https://gasolwu.mit-license.org/license.txt).

View [license information](https://trac.edgewall.org/wiki/TracLicense) for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
