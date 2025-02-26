# Bundle id

To get the bundle id of a macOS application, run this command:

```sh
osascript -e 'id of app "facetime"'
```

Or:

```sh
mdls -name kMDItemCFBundleIdentifier -r SomeApp.app
```

Example:

```sh
$ mdls -name kMDItemCFBundleIdentifier -r /Applications/zoom.us.app 
us.zoom.xos
```


BUNDLE_ID_MAIL = "com.apple.mobilemail"
BUNDLE_ID_PHONE = "com.apple.mobilephone"
BUNDLE_ID_SMS = "com.apple.MobileSMS"
