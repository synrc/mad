MAD
===

A simple rebar-compatible dependency manager and developer tool with plugins.

![MAD](http://synrc.com/images/mad.png)

Goals
-----

It shall:

* be compatible with rebar configuration.
* be as small and fast as possible.

Features
--------

* Colorful REPL
* Support rebar.config
* Support OTP releases and directory structure
* Fast deps resolving and cycles detecting
* Fast compilation
* DTL/YECC/LEEX/PORT/SCRIPT/APP/ERL compilation
* BEAM bundles (single-file escriptized app)
* LING bundles (single-file with built-in LING)
* BEAM releases (faster and smaller than RELX)
* Cloud Profiles
* Start/Stop/Attach
* Static files generation with node.js tools
* 9p server for remote access

Profiles
--------

```

           MAD      VZ      LING    DOCKER
 create    priv     tar     tar     tar
 release   tgz      tgz     img     tgz
 start     run_erl  chroot  xl      docker
 stop      kill     kill    xl      docker
 push      git      scp     scp     docker

 deps      x
 compile   x
 plan      x
 
```

Build
-----

```sh
    $ make
```

And put `mad` to PATH.

BEAM Lightweight Unikernel Bundle
---------------------------------

Bundle is a gzipped archive of erlang beams of all dependecies
along with directory structure of OTP-applications with priv directories.
This allows you to pack all site inside single portable escript package able
to run under Windows, Linux and Mac. Releases includes all current
directory exept sources both code and data with all dependencies. You may think of BEAM 
Lightweight Unikernel Bundle as of fixed Erlang releases.

```sh
    $ ./mad app sample
    $ cd sample
    $ ../mad deps compile plan bundle sample
    $ ./sample repl
```

LING Unikernel
--------------

Sample rebar.config for your application you want to go unikernel:

```erlang
{deps_dir,"deps"}.
{deps, [{ling, ".*", {git, "git://github.com/cloudozer/ling", {tag, "master"}}},
        {sh, ".*",   {git, "git://github.com/synrc/sh",       {tag, "1.4"}}}]}.
```

Now you should build LING/posix:

```sh
    $ ./mad dep
    $ cd deps/ling
    $ ARCH=posix make
```

Now pack vmling.o, your OTP apps and rest static to single-file LING bundle with VM inside.

```sh
    $ ./mad lin
Ling Params: []
ARCH: posix_x86
Bundle Name: mad
System: [compiler,syntax_tools,sasl,tools,mnesia,reltool,xmerl,crypto,kernel,
         stdlib,wx,webtool,ssl,runtime_tools,public_key,observer,inets,asn1,
         et,eunit,hipe,os_mon]
Apps: [kernel,stdlib,sh,mad]
Overlay: ["crypto.beam","9p.beam","9p_auth.beam","9p_info.beam",
          "9p_mounter.beam","9p_server.beam","9p_tcp.beam","9p_zero.beam",
          "disk.beam","disk_server.beam","embedded_export.beam",
          "goo_export.beam","goofs.beam","hipe_unified_loader.beam",
          "inet_config.beam","kernel.beam","ling_bifs.beam","ling_code.beam",
          "ling_disasm.beam","ling_iops.beam","ling_iopvars.beam",
          "ling_lib.beam","net_vif.beam","os.beam","prim_file.beam",
          "user_drv.beam","os_mon.beam","dets.beam","filename.beam",
          "maps.beam","unicode.beam","zlib.beam"]
Bucks: [{boot,"/boot",2},
        {os_mon,"/erlang/lib/os_mon/ebin",1},
        {crypto,"/erlang/lib/crypto/ebin",1},
        {kernel,"/erlang/lib/kernel/ebin",90},
        {stdlib,"/erlang/lib/stdlib/ebin",85},
        {sh,"/erlang/lib/sh/ebin",6},
        {mad,"/erlang/lib/mad/ebin",43}]
Initializing EMBED.FS:
Mount View:
 /boot /boot
/erlang/lib/os_mon/ebin /os_mon
/erlang/lib/crypto/ebin /crypto
/erlang/lib/kernel/ebin /kernel
/erlang/lib/stdlib/ebin /stdlib
/erlang/lib/sh/ebin /sh
/erlang/lib/mad/ebin /mad
Creating EMBED.FS C file: ...ok
Compilation of Filesystem object: ...ok
Linking Image: ok
```

Run it:

```sh
$ rlwrap ./image.img
Erlang [ling-0.5]

Eshell V6.3  (abort with ^G)
1> application:which_applications().
[{mad,"MAD VXZ Build Tool","2.2"},
 {sh,"VXZ SH Executor","0.9"},
 {stdlib,"ERTS  CXC 138 10","2.2"},
 {kernel,"ERTS  CXC 138 10","3.0.3"}]
```

See details in [http://maxim.livejournal.com/458016.html](http://maxim.livejournal.com/458016.html) 

Building OTP Release
--------------------

Releases are bundles made by release_handler module of sasl applications.
It has it own fat bootstripts along with erlang runtime included.
This allows you to distribute you applications with copy deploy
without Erlang prerequisite.

```sh
    $ ./mad app sample
    $ cd sample
    $ ../mad dep com pla rel
```

Support
-------
* [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/5HT/n2o?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
* IRC Channel #n2o on FreeNode 24/7

Documentation
-------

If you are new or need to determine whether the MAD architecture and
philosophy is a fit for your project

* Official MAD brochure [PDF](http://synrc.com/apps/mad/doc/book.pdf)

Credits
-------

* Maxim Sokhatsky
* Sina Samavati
* Vladimir Kirillov

OM A HUM
