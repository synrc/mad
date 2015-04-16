MAD
===

A simple rebar-compatible dependency manager.

![MAD](http://synrc.com/lj/mad.png)

Goals
-----

It shall:

* be compatible with rebar configuration.
* be as small and fast as possible.

Build
-----

    $ make

And put 'mad' to PATH.

Unikernel Bundle
----------------

Bundle is a gzipped archive of erlang beams of all dependecies
along with directory structure of OTP-applications with priv directories.
This allows you to pack all site inside single portable escript package able
to run under Windows, Linux and Mac. Releases includes all current
directory exept sources both code and data with all dependencies.

    $ mad app "sample"
    $ cd sample
    $ mad deps compile plan bundle "web_app"
    $ ./web_app

Building OTP Release
--------------------

Releases are bundles made by release_handler module of sasl applications.
It has it own fat bootstripts along with erlang runtime included.
This allows you to distribute you applications with copy deploy
without Erlang prerequisite.

    $ mad app sample
    $ cd sample
    $ mad dep com pla release
    $ _rel/sample/bin/sample console

Note: [relx](https://github.com/erlware/relx) must be installed
LINUX NOTE: if you want to have online recompilation you should do at first:

    $ sudo apt-get install inotify-tools

Support
-------
* [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/5HT/n2o?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
* IRC Channel #n2o on FreeNode 24/7

Documentation
-------

If you are new or need to determine whether the MAD architecture and
philosophy is a fit for your project

* Official MAD brochure [HTML](http://synrc.com/apps/mad/) and
                        [PDF](https://synrc.com/apps/mad/doc/book.pdf)

Credits
-------

* Maxim Sokhatsky
* Sina Samavati
* Vladimir Kirillov

OM A HUM
