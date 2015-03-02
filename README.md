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

Credits
-------

* Maxim Sokhatsky
* Sina Samavati
* Vladimir Kirillov

OM A HUM
