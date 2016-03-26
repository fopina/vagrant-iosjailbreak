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
------------------

For this example we'll tweak Shazam to show an alert when you tap the big Shazam button.

We'll need to install these on your iOS device:
* Clutch - compiled from [source](https://github.com/KJCracks/Clutch) or download a [released binary](https://github.com/KJCracks/Clutch/releases/tag/Clutch-2.0.1)
* class-dump - available in [cydia official repositories](https://cydia.saurik.com/info/class-dump/)

* Use `Clutch` to find the bundle id and decrypt the app:

  ```
  vagrant@jailbreakdev:~$ sshi

  192.168.33.33:~ root# Clutch -i | grep -i shazam
  4:   Shazam <com.shazam.Shazam>

  192.168.33.33:~ root# Clutch -b 4
  Now dumping com.shazam.Shazam
  com.shazam.Shazam contains watchOS 2 compatible application. It's not possible to dump watchOS 2 apps with Clutch 2.0.1 at this moment.
  Preparing to dump <Shazam>
  Path: /private/var/mobile/Applications/223F3305-0F64-4EA6-B18F-662BFAED9B16/Shazam.app/Shazam
  Dumping <Shazam> (armv7)
  DUMP | ARMDumper <armv7> <Shazam> Patched cryptid (32bit segment)
  DUMP | ARMDumper <armv7> <Shazam> Writing new checksum
  Finished 'stripping' binary <Shazam>
  Note: This binary will be missing some undecryptable architectures

  Finished dumping com.shazam.Shazam to /var/tmp/clutch/06F58677-FD02-405F-B6BB-65B32F102935
  Finished dumping com.shazam.Shazam in 9.9 seconds

  192.168.33.33:~ root# class-dump -H -o shazam /var/tmp/clutch/06F58677-FD02-405F-B6BB-65B32F102935/com.shazam.Shazam/Shazam
  192.168.33.33:~ root# logout
  Connection to 192.168.33.33 closed.

  vagrant@jailbreakdev:~$ cd /share/
  vagrant@jailbreakdev:/share$ nic.pl -t iphone/tweak -p com.skmobi.shazamtweak -n ShazamTweak -u fopina
  NIC 2.0 - New Instance Creator
  ------------------------------
  [iphone/tweak] MobileSubstrate Bundle filter [com.apple.springboard]: com.shazam.Shazam
  [iphone/tweak] List of applications to terminate upon installation (space-separated, '-' for none) [SpringBoard]: Shazam
  Instantiating iphone/tweak in shazamtweak/...
  Done.

  vagrant@jailbreakdev:/share$ scp -r root@$THEOS_DEVICE_IP:shazam/ shazamtweak/headers
  ```

  * As the tab is called *Home*, we can make an educated guess that the view controller header will contain *home* and end in *controller*

  ```
  vagrant@jailbreakdev:/share/shazamtweak$ find . -iname *home*controller*
  ./headers/SHNewsHomeScreenViewController.h
  ```

  * As we look through *SHNewsHomeScreenViewController* header we can see a method called `taggingViewDidStartTagging`, let's hook it up. Update *Tweak.xm* with

  ```
  @interface SHNewsHomeScreenViewController
  - (void)taggingViewDidStartTagging;
  @end

  %hook SHNewsHomeScreenViewController

  - (void)taggingViewDidStartTagging {
  	%orig;
  	UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@""
  			message:@"Shazam!!!"
  			delegate:self
  			cancelButtonTitle:@"OK..."
  			otherButtonTitles:nil];
  	[alert1 show];
  	[alert1 release];
  }

  %end
  ```

  * Open the `Makefile` and add `ShazamTweak_FRAMEWORKS = UIKit` after the line starting with `ShazamTweak_FILES` to be able to use alerts

  * Compile, package and install: `make && make package && make install`

  * Open Shazam and "Touch to Shazam"!
