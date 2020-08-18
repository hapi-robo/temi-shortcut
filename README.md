# temi Shortcut

Automatically creates a Launcher shortcut on [temi](https://www.robotemi.com/) that links to a pre-installed APK.

These scripts have currently been tested on:
* Ubuntu 18.04


## TL;DR
Clone the repository:
```
git clone https://github.com/hapi-robo/temi-shortcut.git
cd temi-shortcut/
```

Create shortcut:
```
./shortcut.sh <package-name> <shortcut-name>
```

For example, to create a shortcut for Chrome:
```
./shortcut.sh com.android.chrome "Chrome"
```

The file `chrome_shortcut.apk` should then appear in the same directory. Install it onto your device, along with the package that it links to. For this example:
```
adb install chrome.apk
adb install chrome_shortcut.apk
```

### APK Package-Name
If the APK is already installed on the device, you can look for it using:
```
adb shell pm list packages
```

If the package is on your computer, you can run the following script:
```
./package_name.sh <apk>
```


## Dependencies
Scripts in this repository require the Android SDK, which is included in [Android Studio](https://developer.android.com/studio/). Once installed, export the SDK's path to the `ANDROID_HOME` environment variable, for example:
```
export ANDROID_HOME=/path/to/Android/Sdk/
```


## Usage
### shortcut.sh
Creates an APK (visible on temi's Launcher) that launches another APK. This can be used to run APKs that are hidden from temi's Launcher.
```
usage: shortcut.sh <package-name> <shortcut-name>

Creates a shortcut for APK file

dependencies:

  - Android-SDK with the ANDROID_HOME environment variable
    set appropriately.

positional arguments:

  package-name          Android application package name
  shortcut-name         Shortcut name. Use double-quotes to encapsulate
                        a name with whitespace.
```

### package_name.sh
Returns an APK's package-name.
```
usage: package_name.sh <apk>

Returns the APK's package-name

dependencies:

  This script depends on having the Android-SDK installed and having the
  the ANDROID_HOME environment variable set appropriately.

positional arguments:

  apk           		APK filename (.apk)
```