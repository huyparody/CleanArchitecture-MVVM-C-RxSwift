if brew ls --versions xcodegen > /dev/null; then
  # The package is installed
  echo "XcodeGen is installed..."
  rm -rf CleanArchitecture-MVVM-C-RxSwift.xcodeproj && xcodegen
  echo "\nDone, now open the .xcodeprj file.\n"
else
  # The package is not installed
  echo "XcodeGen is not installed...\nInstalling XcodeGen..."
  brew install xcodegen && rm -rf CleanArchitecture-MVVM-C-RxSwift.xcodeproj && xcodegen && brew list
  echo "\nDone, now open the .xcodeprj file.\n"
fi
