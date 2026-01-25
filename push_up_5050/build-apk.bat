@echo off
cd /d "C:\Script\Android-Apps\Push-up flutter Nuovo test\push_up_5050"
flutter build apk --release
echo Build complete!
dir build\app\outputs\flutter-apk\app-release.apk
pause
