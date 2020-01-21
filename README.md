# temi Shortcut

Automatically creates a Launcher shortcut on [temi](https://www.robotemi.com/) that links to a pre-installed APK.

These scripts have currently been tested on:
* Ubuntu 18.04


## TL;DR
Get the APK's `package-name`:
```
./package_name.sh <apk>
```

This will output the APK's `package-name`, which is used in the following:
```
./shortcut.sh <package-name> <shortcut-name>
```

For example, to create a shortcut for Chrome:
```
$ ./package_name.sh chrome.apk
com.android.chrome
$ ./shortcut.sh com.android.chrome "Chrome"
```

The file `chrome_shortcut.apk` should then appear in the same directory.


## Dependencies
### curl
```
sudo apt-get update
sudo apt-get install curl
```

### Android SDK
Refer to [Android SDK installation instructions](https://www.androidcentral.com/installing-android-sdk-windows-mac-and-linux-tutorial)

Export the SDK's path to the `ANDROID_HOME` environment variable, for example:
```
export=/path/to/Android/Sdk/
```

## Usage
### package_name.sh
Returns an APK's the package-name.
```
usage: package_name.sh <apk>

Returns the APK's package-name

dependencies:

  This script depends on having the Android-SDK installed and having the
  the ANDROID_HOME environment variable set appropriately.

positional arguments:

  apk           APK filename (.apk)
```

### shortcut.sh
Creates an APK (visible on temi's Launcher) that launches another APK. This can be used to run APKs that are hidden from temi's Launcher.
```
usage: shortcut.sh <package-name> <shortcut_name>

Creates a shortcut for APK file

dependencies:

  - curl
  - Android-SDK with the ANDROID_HOME environment variable
    set appropriately.

positional arguments:

  package-name          Android application package name
  shortcut_name         Shortcut name. Use double-quotes to encapsulate
                        a name with whitespace.
```

