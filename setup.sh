#!/bin/bash
PROJECT_NAME="CleanArchitecture-MVVM-C-RxSwift"

if brew ls --versions xcodegen > /dev/null; then
  # The package is installed
  echo "XcodeGen is installed..."
  rm -rf $PROJECT_NAME.xcodeproj && xcodegen && open $PROJECT_NAME.xcodeproj
else
  # The package is not installed
  echo "XcodeGen is not installed...\nInstalling XcodeGen..."
  brew install xcodegen && rm -rf $PROJECT_NAME.xcodeproj && xcodegen && open $PROJECT_NAME.xcodeproj
fi
