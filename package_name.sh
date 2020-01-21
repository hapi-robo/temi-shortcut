#!/bin/sh
#
# Returns the APK's package-name
#
# Usage
#	  ./package_name.sh <apk>
#
# Dependencies
#   - Android SDK, see: https://www.androidcentral.com/installing-android-sdk-windows-mac-and-linux-tutorial
#
# MIT License
#
# Copyright (c) 2019 Raymond Oung
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

# display usage instructions
usage()
{
  echo ""
  echo "usage: package_name.sh <apk>"
  echo ""
  echo "Returns the APK's package-name"
  echo ""
  echo "dependencies:"
  echo ""
  echo "  This script depends on having the Android-SDK installed and having the"
  echo "  the ANDROID_HOME environment variable set appropriately."
  echo ""
  echo "positional arguments:"
  echo ""
  echo "  apk           APK filename (.apk)"
  echo ""
  exit 1
}

# check for APK file
if [ -z "$1" ]; then
  echo "Missing APK file"
  usage
else
  APK_FILENAME=$1
fi

# get package name
PACKAGE_NAME="$(aapt dump badging "${APK_FILENAME}" | awk -F "[='|' ]" '/package: / {print $4}')"

# get package name (alternative)
# PACKAGE_NAME="$(aapt dump badging "${APK}" | grep "package" | sed -r "s/package: name='(.+)' versionCode.*/\1/")"

echo "${PACKAGE_NAME}"
exit 0