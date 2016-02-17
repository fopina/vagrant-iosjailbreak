Vagrant file to quickly jump into jailbreak tweak development.

Full setup with Theos, toolchain and iOS 8.1 SDK.

Also included a small shortcut bash function `setphone` to make it easier to set (and persist) `THEOS_DEVICE_IP` variable

Quickstart
----------

```
git clone https://github.com/fopina/vagrant-iosjailbreak
cd vagrant-iosjailbreak
vagrant up
```

Now just `vagrant ssh` and create your tools/tweaks using Theos

Hello World
-----------

```
skmac:vagrant-iosjailbreak fopina$ vagrant ssh

Welcome to JBDev VM.
Report issues in https://github.com/fopina/vagrant-iosjailbreak

You have mail.
Last login: Wed Feb 17 15:23:35 2016 from 10.0.2.2
vagrant@jailbreakdev:~$ nic.pl helloworld
NIC 2.0 - New Instance Creator
------------------------------
  [1.] iphone/activator_event
  [2.] iphone/application_modern
  [3.] iphone/cydget
  [4.] iphone/flipswitch_switch
  [5.] iphone/framework
  [6.] iphone/ios7_notification_center_widget
  [7.] iphone/library
  [8.] iphone/notification_center_widget
  [9.] iphone/preference_bundle_modern
  [10.] iphone/tool
  [11.] iphone/tweak
  [12.] iphone/xpc_service
Choose a Template (required): 10
Package Name [com.yourcompany.helloworld]:
Author/Maintainer Name [Vagrant Default User]:
Instantiating iphone/tool in helloworld/...
Done.
vagrant@jailbreakdev:~$ cd helloworld/
vagrant@jailbreakdev:~/helloworld$ sed -i 's/return 0/puts\("hello world"\)/' main.mm
vagrant@jailbreakdev:~/helloworld$ make
> Making all for tool helloworld…
==> Compiling main.mm (armv7)…
==> Linking tool helloworld (armv7)…
==> Compiling main.mm (arm64)…
==> Linking tool helloworld (arm64)…
==> Merging tool helloworld…
==> Signing helloworld…
vagrant@jailbreakdev:~/helloworld$ make package
> Making all for tool helloworld…
make[2]: Nothing to be done for 'internal-tool-compile'.
> Making stage for tool helloworld…
dpkg-deb: warning: deprecated compression type 'lzma'; use xz instead
dpkg-deb: warning: ignoring 1 warning about the control file(s)
dpkg-deb: building package `com.yourcompany.helloworld' in `./debs/com.yourcompany.helloworld_0.0.1-1+debug_iphoneos-arm.deb'.
vagrant@jailbreakdev:~/helloworld$ setphone skFive
vagrant@jailbreakdev:~/helloworld$ make install
==> Installing…
root@skfive's password:
Selecting previously deselected package com.yourcompany.helloworld.
(Reading database ... 2560 files and directories currently installed.)
Unpacking com.yourcompany.helloworld (from /tmp/_theos_install.deb) ...
Setting up com.yourcompany.helloworld (0.0.1-1+debug) ...
vagrant@jailbreakdev:~/helloworld$ ssh mobile@skFive /usr/bin/helloworld
mobile@skfive's password:
hello world
vagrant@jailbreakdev:~/helloworld$
```

Links
-----
* [Theos]( http://iphonedevwiki.net/index.php/Theos/Setup#On_Mac_OS_X_or_Linux)
* [Linux iOS Toolchain](https://github.com/tpoechtrager/cctools-port/)
* [iOS SDK](http://iphone.howett.net/sdks/)
