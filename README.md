<img src="https://github.com/OpenIMSDK/OpenIM-Docs/blob/main/docs/images/WechatIMG20.jpeg" alt="image" style="width: 350px; " />

## Can be used for free, must be added on the app startup page (powered by OpenIM)

### OpenIM
A OpenIM flutter demo, only support android and ios.

![image](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/gif/1.gif)


### Official demo use

##### 1. Download the experience app

![Android](https://www.pgyer.com/app/qrcode/OpenIM-Flutter)

##### 2. Replace the server address with the server address built by yourself, and the default address is the official server address

![image](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/gif/2.gif)


### source code usage

1. git clone https://github.com/OpenIMSDK/Open-IM-Flutter-Demo.git
2. modify the server address in the [config.dart](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/lib/src/common/config.dart) file to the server address built by yourself
3. flutter pub get
4. flutter run

### The sdk used by the new version UI is the main branch, flutter version 3.7.7

###### Please replace the sdk dependency with git dependency
```dart
  flutter_openim_sdk:
    git:
        url: https: //github.com/OpenIMSDK/Open-IM-SDK-Flutter.git
```

### other

The im library link used by the demo: [flutter_openim_sdk ](https://github.com/OpenIMSDK/Open-IM-SDK-Flutter.git)

### Issues

##### 1. Does it support multiple languages?

A: Support, follow the system language by default

##### 2. What is the flutter version corresponding to the demo?

A: stable branch 3.7.12

##### 3. Which platforms are supported?

A: The demo currently supports android and ios.

##### 4. The debug of the android installation package can run, but the release starts with a white screen?

A: The release package of flutter is obfuscated by default. You can use the command: flutter build release --no -shrink. If this command is invalid, you can do the following

Add the following configuration to the release configuration configured in android/app/build.gradle

```
release {
    minifyEnabled false
    useProguard false
    shrinkResources false
}
```

##### 5. What should I do if the code must be confused?

A: Add the following rules to the obfuscation rules

```
-keep class io.openim.**{*;}
-keep class open_im_sdk.**{*;}
-keep class open_im_sdk_callback.**{*;}
```

##### 6. The android installation package cannot be installed on the emulator?

A: Because the Demo has removed some cpu architectures, if you want to run it on the emulator, please do the following:

Add in android/build.gradle configuration

```
ndk {
    abiFilters "arm64-v8a", "armeabi-v7a", "armeabi", "x86", "x86_64"
}
```

##### 7, ios run/build release package error

A: Please set the CPU architecture to arm64, and then operate as follows

- flutter clean
- flutter pub get
- cd ios
- pod install
- rm -f Podfile.lock
- rm -rf Pods
- Run Archive after connecting to the real device

![ios cpu](https://user-images.githubusercontent.com/7018230/155913400-6231329a-aee9-4082-8d24-a25baad55261.png)

##### 8. What is the minimum version number for ios to run?

A: 13.0

#### 9. Some developers encountered the following problems:
```
Could not build the precompiled application for the device.
Error (Xcode): Signing for "TOCropViewController-TOCropViewControllerBundle" requires a development team. Select a development team
in the Signing & Capabilities editor.

Error (Xcode): Signing for "DKImagePickerController-DKImagePickerController" requires a development team. Select a development team
in the Signing & Capabilities editor.

Error (Xcode): Signing for "DKPhotoGallery-DKPhotoGallery" requires a development team. Select a development team in the Signing &
Capabilities editor.
```
Add the following code to Podfile:
```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"      end
   end
end
```
