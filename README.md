<p align="center">
    <a href="https://www.openim.io">
        <img src="./openim-logo.gif" width="60%" height="30%"/>
    </a>
</p>

# OpenIM Flutter Demo 💬💻

<p>
  <a href="https://doc.openim.io/">OpenIM Docs</a>
  •
  <a href="https://github.com/openimsdk/open-im-server">OpenIM Server</a>
  •
  <a href="https://github.com/openimsdk/openim-sdk-core">openim-sdk-core</a>
  •
  <a href="https://github.com/openimsdk/open-im-sdk-flutter">open-im-sdk-flutter</a>

</p>

<br>

A OpenIM flutter demo, only support android and ios.

## Tech Stack 🛠️

- This is a [`Flutter`](https://flutter.dev/) project.
- App is built with [open-im-sdk-flutter](https://github.com/openimsdk/open-im-sdk-flutter) library.

## Official demo use

- Download the experience app

  ![Android](https://www.pgyer.com/app/qrcode/IM-FCER)

## Dev Setup 🛠️
1. Android Studio/VsCode
2. Flutter version 3.22.3

## Build 🚀

1. Git clone https://github.com/OpenIMSDK/Open-IM-Flutter-Demo.git
2. Modify the server address in the [config.dart](https://github.com/openimsdk/open-im-flutter-demo/blob/main/openim_common/lib/src/config.dart) file to the server address built by yourself

```dart
  static const _host = "your-server-ip/domain";
```
3. Please replace the IM SDK version
```dart
// openim_common/pubspec.yaml
// openim_live/pubspec.yaml
// pubspec.yaml

  flutter_openim_sdk: lastest
```
4. Get dependencies and perform compilation operations.
```dash
 $ flutter pub get
 $ flutter run
```

### Issues :bookmark_tabs:

##### 1. Does it support multiple languages?

A: Support, follow the system language by default

##### 2. Which platforms are supported?

A: The demo currently supports android and ios.

##### 3. The debug of the android installation package can run, but the release starts with a white screen?

A: The release package of flutter is obfuscated by default. You can use the command: flutter build release --no -shrink. If this command is invalid, you can do the following

Add the following configuration to the release configuration configured in android/app/build.gradle

```
release {
    minifyEnabled false
    useProguard false
    shrinkResources false
}
```

##### 4. What should I do if the code must be confused?

A: Add the following rules to the obfuscation rules

```
-keep class io.openim.**{*;}
-keep class open_im_sdk.**{*;}
-keep class open_im_sdk_callback.**{*;}
```

##### 5. The android installation package cannot be installed on the emulator?

A: Because the Demo has removed some cpu architectures, if you want to run it on the emulator, please do the following:

Add in android/build.gradle configuration

```
ndk {
    abiFilters "armeabi-v7a",  "x86"
}
```

##### 6, ios run/build release package error

A: Please set the CPU architecture to arm64, and then operate as follows

- flutter clean
- flutter pub get
- cd ios
- rm -f Podfile.lock
- rm -rf Pods
- pod install
- Run Archive after connecting to the real device

![ios cpu](https://user-images.githubusercontent.com/7018230/155913400-6231329a-aee9-4082-8d24-a25baad55261.png)

##### 7. What is the minimum version number for ios to run?

A: 13.0

#### 8. Some developers encountered the following problems:
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

## Community :busts_in_silhouette:

- 📚 [OpenIM Community](https://github.com/OpenIMSDK/community)
- 💕 [OpenIM Interest Group](https://github.com/Openim-sigs)
- 🚀 [Join our Slack community](https://join.slack.com/t/openimsdk/shared_invite/zt-2ijy1ys1f-O0aEDCr7ExRZ7mwsHAVg9A)
- :eyes: [Join our wechat (微信群)](https://openim-1253691595.cos.ap-nanjing.myqcloud.com/WechatIMG20.jpeg)

## Community Meetings :calendar:

We want anyone to get involved in our community and contributing code, we offer gifts and rewards, and we welcome you to join us every Thursday night.

Our conference is in the [OpenIM Slack](https://join.slack.com/t/openimsdk/shared_invite/zt-22720d66b-o_FvKxMTGXtcnnnHiMqe9Q) 🎯, then you can search the Open-IM-Server pipeline to join

We take notes of each [biweekly meeting](https://github.com/orgs/OpenIMSDK/discussions/categories/meeting) in [GitHub discussions](https://github.com/openimsdk/open-im-server/discussions/categories/meeting), Our historical meeting notes, as well as replays of the meetings are available at [Google Docs :bookmark_tabs:](https://docs.google.com/document/d/1nx8MDpuG74NASx081JcCpxPgDITNTpIIos0DS6Vr9GU/edit?usp=sharing).

## Who are using OpenIM :eyes:

Check out our [user case studies](https://github.com/OpenIMSDK/community/blob/main/ADOPTERS.md) page for a list of the project users. Don't hesitate to leave a [📝comment](https://github.com/openimsdk/open-im-server/issues/379) and share your use case.

## License :page_facing_up:

OpenIM is licensed under the Apache 2.0 license. See [LICENSE](https://github.com/openimsdk/open-im-server/tree/main/LICENSE) for the full license text.
