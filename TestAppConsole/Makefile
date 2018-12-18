all:
	make ios
	make osx

ios:
	xcodebuild -workspace TestAppConsole.xcworkspace/ -scheme TestiOS -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.0' -derivedDataPath ./DerivedData -quiet build
	otool -L ./DerivedData/Build/Products/Debug-iphonesimulator/TestiOS.app/TestiOS

osx:
	xcodebuild -workspace TestAppConsole.xcworkspace/ -scheme TestAppConsole -destination 'platform=macOS,arch=x86_64' -showBuildTimingSummary -derivedDataPath ./DerivedData -quiet build
	./DerivedData/Build/Products/Debug/TestAppConsole
