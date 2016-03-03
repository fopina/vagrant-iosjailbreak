Examples
========

* [iphone/tool](#tool)
* [iphone/tweak](#tweak)
* [iphone/tweak for AppStore app](#tweak-appstore-app)

Tool
----

Simple command line tool that prints, yup, `hello world`.

Working inside `/share` will keep everything in the host machine instead of the VM.  
Cool to quickly clone in your host machine and compile inside the VM.

```
skmac:vagrant-iosjailbreak fopina$ vagrant ssh

Welcome to JBDev VM.
Report issues in https://github.com/fopina/vagrant-iosjailbreak

Last login: Wed Feb 17 15:23:35 2016 from 10.0.2.2
vagrant@jailbreakdev:~$ cd /share
vagrant@jailbreakdev:/share$ nic.pl helloworld
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
vagrant@jailbreakdev:/share$ cd helloworld/
vagrant@jailbreakdev:/share/helloworld$ sed -i 's/return 0/puts\("hello world"\)/' main.mm
vagrant@jailbreakdev:/share/helloworld$ make
> Making all for tool helloworld…
==> Compiling main.mm (armv7)…
==> Linking tool helloworld (armv7)…
==> Compiling main.mm (arm64)…
==> Linking tool helloworld (arm64)…
==> Merging tool helloworld…
==> Signing helloworld…
vagrant@jailbreakdev:/share/helloworld$ make package
> Making all for tool helloworld…
make[2]: Nothing to be done for 'internal-tool-compile'.
> Making stage for tool helloworld…
dpkg-deb: warning: deprecated compression type 'lzma'; use xz instead
dpkg-deb: warning: ignoring 1 warning about the control file(s)
dpkg-deb: building package `com.yourcompany.helloworld' in `./debs/com.yourcompany.helloworld_0.0.1-1+debug_iphoneos-arm.deb'.
vagrant@jailbreakdev:/share/helloworld$ setphone 192.168.33.33
vagrant@jailbreakdev:/share/helloworld$ make install
==> Installing…
root@192.168.33.33's password:
Selecting previously deselected package com.yourcompany.helloworld.
(Reading database ... 2560 files and directories currently installed.)
Unpacking com.yourcompany.helloworld (from /tmp/_theos_install.deb) ...
Setting up com.yourcompany.helloworld (0.0.1-1+debug) ...
vagrant@jailbreakdev:/share/helloworld$ sshi helloworld
mobile@192.168.33.33's password:
hello world
```

Tweak
----

Let's hook *SpringBoard* `applicationDidFinishLaunching` method (based on [this example](https://github.com/codyd51/Theos-Examples/tree/e73a8d0a7574ecc6eaa7322b14f54fcf57658392/RespringNotifier)) to popup an alert.  
Basically it will be a reboot/respring notification!

* Create the project:

  ```
  vagrant@jailbreakdev:/share$ nic.pl -t iphone/tweak -p com.skmobi.respringhello -n SpringHello -u fopina
  NIC 2.0 - New Instance Creator
  ------------------------------
  [iphone/tweak] MobileSubstrate Bundle filter [com.apple.springboard]:
  [iphone/tweak] List of applications to terminate upon installation (space-separated, '-' for none) [SpringBoard]:
  Instantiating iphone/tweak in springhello/...
  Done.
  ```

* Replace the content of `Tweak.xm` with:

  ```
  %hook SpringBoard

  -(void)applicationDidFinishLaunching:(id)application {
      %orig;

      UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Welcome"
          message:@"Resprung!"
          delegate:self
          cancelButtonTitle:@"OK..."
          otherButtonTitles:nil];
      [alert1 show];
      [alert1 release];
  }

  %end
  ```

* Open the `Makefile` and  add `SpringHello_FRAMEWORKS = UIKit` after the line starting with `SpringHello_FILES`

* Compile, package and install

  ```
  vagrant@jailbreakdev:/share/springhello$ make
  > Making all for tweak SpringHello…
  ==> Preprocessing Tweak.xm…
  ==> Compiling Tweak.xm (armv7)…
  ==> Linking tweak SpringHello (armv7)…
  ==> Preprocessing Tweak.xm…
  ==> Compiling Tweak.xm (arm64)…
  ==> Linking tweak SpringHello (arm64)…
  ==> Merging tweak SpringHello…
  ==> Signing SpringHello…
  vagrant@jailbreakdev:/share/springhello$ make package
  > Making all for tweak SpringHello…
  make[2]: Nothing to be done for 'internal-library-compile'.
  > Making stage for tweak SpringHello…
  dpkg-deb: warning: deprecated compression type 'lzma'; use xz instead
  dpkg-deb: warning: ignoring 1 warning about the control file(s)
  dpkg-deb: building package `com.skmobi.respringhello' in `./debs/com.skmobi.respringhello_0.0.1-1+debug_iphoneos-arm.deb'.
  vagrant@jailbreakdev:/share/springhello$ make install
  ==> Installing…
  root@192.168.33.33's password:
  Selecting previously deselected package com.skmobi.respringhello.
  (Reading database ... 2561 files and directories currently installed.)
  Unpacking com.skmobi.respringhello (from /tmp/_theos_install.deb) ...
  Setting up com.skmobi.respringhello (0.0.1-1+debug) ...
  install.exec "killall -9 SpringBoard"
  root@192.168.33.33's password:
  vagrant@jailbreakdev:/share/springhello$
  ```

*SpringBoard* will restart (aka *respring*) and you'll get the alert.

Tweak AppStore App
----
ToDo
