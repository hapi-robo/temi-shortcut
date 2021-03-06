#!/bin/sh
#
# Automatically creates a Launcher shortcut on temi that links to a pre-installed APK.
#
# Usage
#	  ./shortcut.sh <apk> <shortcut-name>
#
# MIT License
#
# Copyright (c) 2020 Raymond Oung
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# abort if any command fails
set -e

# constants
DEFAULT_ANDROID_HOME=~/Android/Sdk # default location on Linux
TEMPLATE_DIR="template"
THIS_DIR="$PWD"

# display usage instructions
usage()
{
  echo ""
  echo "usage: shortcut.sh <package-name> <shortcut-name>"
  echo ""
  echo "Creates a shortcut for APK file"
  echo ""
  echo "dependencies:"
  echo ""
  echo "  Android SDK with the ANDROID_HOME environment variable"
  echo "  set appropriately."
  echo ""
  echo "positional arguments:"
  echo ""
  echo "  package-name          Android application package name"
  echo "  shortcut-name         Shortcut name. Use double-quotes to encapsulate"
  echo "                        a name with whitespace."
  echo ""
}

# attempt to automatically set ANDROID_HOME environment variable
set_android_home()
{
	echo "ANDROID_HOME environment variable not set. Attempting to set automatically..."
	if [ -d "${DEFAULT_ANDROID_HOME}" ]; then
		export ANDROID_HOME=${DEFAULT_ANDROID_HOME}
		echo "export ANDROID_HOME=${ANDROID_HOME}"
	else
		echo "[Error] Android SDK cannot be found. Set the ANDROID_HOME environment variable to your Android SDK's path, i.e. Android/Sdk/"
    # echo "[Error] Android SDK cannot be found. Set the ANDROID_SDK_ROOT environment variable to your Android SDK's path, i.e. Android/Sdk/"
    exit 1
	fi
}

# check path to Android SDK
if env | grep -q "^ANDROID_HOME="; then
	if [ -d "${ANDROID_HOME}" ]; then
		echo "ANDROID_HOME environment variable set to ${ANDROID_HOME}."
	else
		set_android_home
	fi
else
	set_android_home
fi

# check for package name
if [ -z "$1" ]; then
  echo "Missing package name"
  usage
  exit 1
else
  PACKAGE_NAME=$1
fi

# check for shortcut name
if [ -z "$2" ]; then
  echo "Missing shortcut name"
  usage
  exit 1
else
  SHORTCUT_NAME=$2
fi

# remove existing directory if any
rm -fr "/tmp/${SHORTCUT_NAME}"

# make a copy of the template
cp -avr "${TEMPLATE_DIR}" "/tmp/${SHORTCUT_NAME}"

# enter shortcut-template source code root directory
cd "/tmp/${SHORTCUT_NAME}"

# rename package
# - lower case letters
# - substitute whitespace ' ' with underscore '_'
SHORTCUT_NAME_UNDERSCORE="$(echo ${SHORTCUT_NAME} | tr '[:upper:]' '[:lower:]' | tr ' ' '_')"

# check environment
UNAME_OUT="$(uname -s)"
case "${UNAME_OUT}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${UNAME_OUT}"
esac

if [ ${MACHINE} = "Linux" ]; then
  # modify files inline (Linux)
  echo "Linux"
  sed -i "s/shortcut_template/shortcut_${SHORTCUT_NAME_UNDERSCORE}/" app/build.gradle
  sed -i "s/shortcut_template/shortcut_${SHORTCUT_NAME_UNDERSCORE}/" app/src/main/AndroidManifest.xml
  sed -i "s/shortcut_template/shortcut_${SHORTCUT_NAME_UNDERSCORE}/" app/src/main/java/com/hapirobo/shortcut_template/MainActivity.java
  sed -i "s/shortcut_name/${SHORTCUT_NAME}/" app/src/main/res/values/strings.xml
  sed -i "s/com.hapirobo.package_name/${PACKAGE_NAME}/" app/src/main/res/values/strings.xml
elif [ ${MACHINE} = "Darwin" ]; then
  # modify files inline
  echo "macOS"
  sed -i .bak "s/shortcut_template/shortcut_${SHORTCUT_NAME_UNDERSCORE}/" app/build.gradle
  sed -i .bak "s/shortcut_template/shortcut_${SHORTCUT_NAME_UNDERSCORE}/" app/src/main/AndroidManifest.xml
  sed -i .bak "s/shortcut_template/shortcut_${SHORTCUT_NAME_UNDERSCORE}/" app/src/main/java/com/hapirobo/shortcut_template/MainActivity.java
  sed -i .bak "s/shortcut_name/${SHORTCUT_NAME}/" app/src/main/res/values/strings.xml
  sed -i .bak "s/com.hapirobo.package_name/${PACKAGE_NAME}/" app/src/main/res/values/strings.xml
else
  echo "[Error] This script only supports Linux and Darwin."
  exit 1
fi

# rename directories
mv -v app/src/main/java/com/hapirobo/shortcut_template "app/src/main/java/com/hapirobo/shortcut_${SHORTCUT_NAME_UNDERSCORE}"

# build shortcut-APK
./gradlew clean
./gradlew build

# move shortcut-APK to root directory
cp app/build/outputs/apk/debug/app-debug.apk "${THIS_DIR}/${SHORTCUT_NAME_UNDERSCORE}_shortcut.apk"

# installation instructions
echo ""
echo "${THIS_DIR}/${SHORTCUT_NAME_UNDERSCORE}_shortcut.apk"
echo "Remember to install both the App and App-shortcut."
exit 0