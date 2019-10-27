MAD: Manage Dependencies
========================

[![Actions Status](https://github.com/synrc/mad/workflows/mix/badge.svg)](https://github.com/synrc/mad/actions)
[![Build Status](https://travis-ci.org/synrc/mad.svg?branch=master)](https://travis-ci.org/synrc/mad)
[![Hex pm](http://img.shields.io/hexpm/v/mad.svg?style=flat)](https://hex.pm/packages/mad)

A simple rebar-compatible dependency manager and developer
tool with plugins for Windows, Linux and Mac.

![MAD](http://synrc.com/images/mad.png)

Goals
-----

It shall:

* be compatible with rebar configuration.
* be as small and fast as possible.

Features
--------

* Support rebar.config
* Support OTP releases and directory structure
* Fast deps resolving and cycles detecting
* Fast compilation
* Small codebase: 1K LOC
* DTL/YECC/LEEX/PORT/SCRIPT/APP/ERL compilation
* BEAM bundles (single-file escriptized app)
* BEAM releases (faster and smaller than RELX)
* Start/Stop/Attach
* Static files generation with node.js tools

Build
-----

```sh
    $ make
```

And put `mad` to PATH.

Building OTP Release
--------------------

Releases are bundles made by release_handler module of sasl applications.
It has it own fat bootstripts along with erlang runtime included.
This allows you to distribute you applications with copy deploy
without Erlang prerequisite.

```sh
    $ ./mad app web sample
    $ cd sample
    $ ../mad dep com pla rel
```

Documentation
-------------

If you are new or need to determine whether the MAD architecture and
philosophy is a fit for your project

* Official MAD brochure [PDF](http://synrc.com/apps/mad/doc/book.pdf)

Credits
-------

* Maxim Sokhatsky
* Sina Samavati
* Vladimir Kirillov
* Taras Taraskin
