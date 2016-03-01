Vagrant file to quickly jump into jailbreak tweak development.

Full setup with Theos, toolchain and iOS 8.1 SDK.

Also included two small shortcut bash functions:

* `setphone` to make it easier to set (and persist - in .profile) `THEOS_DEVICE_IP` variable
* `sshi` to execute `ssh root@$THEOS_DEVICE_IP`

Quickstart
----------

```bash
git clone https://github.com/fopina/vagrant-iosjailbreak
cd vagrant-iosjailbreak
vagrant up
```

Now just `vagrant ssh` and create your tools/tweaks using Theos

Check out [EXAMPLES](EXAMPLES.md)

Links
-----
* [Theos]( http://iphonedevwiki.net/index.php/Theos/Setup#On_Mac_OS_X_or_Linux)
* [Linux iOS Toolchain](https://github.com/tpoechtrager/cctools-port/)
* [iOS SDK](http://iphone.howett.net/sdks/)
