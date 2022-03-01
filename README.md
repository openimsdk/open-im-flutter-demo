## 可以免费使用，必须在app启动页加上 (由OpenIM提供技术支持)

### OpenIM
A OpenIM flutter demo, only support android and ios.

![image](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/gif/QQ20211207-101110.gif)



### Experience the demo app 

##### 1. Download app (下载App)

![Android](https://www.pgyer.com/app/qrcode/OpenIM)

##### 2. Replace server address (替换服务器地址，默认地址为官方服务器地址)

![image](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/gif/QQ20211216-141624.gif)


### Source code build (源代码使用)

1. git clone https://github.com/OpenIMSDK/Open-IM-Flutter-Demo.git
2. modify the server address in [config.dart](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/lib/src/common/config.dart)
3. flutter pub get
4. flutter run

### Other

[flutter_openim_widget [demo使用的ui库]](https://github.com/hrxiang/flutter_openim_widget.git)

[flutter_openim_sdk [demo使用的im库]](https://github.com/OpenIMSDK/Open-IM-SDK-Flutter.git)

### Issues

##### 1，demo对应的flutter版本是？

答：stable分支2.10.1

##### 2，android安装包debug可以运行但release启动白屏？

答：flutter的release包默认是开启了混淆，可以使用命令：flutter build release --no -shrink，如果此命令无效可如下操作

在android/build.gradle配置的release配置加入以下配置

```
release {
    minifyEnabled false
    useProguard false
    shrinkResources false
}
```

##### 3，代码必须混淆怎么办？

答：在混淆规则里加入以下规则

```
-keep class io.openim.**{*;}
-keep class open_im_sdk.**{*;}
-keep class open_im_sdk_callback.**{*;}
```

##### 4，android安装包不能安装在模拟器上？

答：因为Demo去掉了某些cpu架构，如果你想运行在模拟器上请按以下方式：

在android/build.gradle配置加入

```
ndk {
    abiFilters "arm64-v8a", "armeabi-v7a", "armeabi", "x86", "x86_64"
}
```

##### 5，demo编译ios时为什么不能在模拟器上运行只能在真机上运行

答：插件依赖方式flutter_openim_sdk: ^xxx 只能运行在真机上。如果既想在模拟器上运行又想在真机上运行，可以使用以下依赖方式：

```
flutter_openim_sdk:
       git:
          url: https://github.com/OpenIMSDK/Open-IM-SDK-Flutter.git
          ref: fix-ios-simulator
```

##### 6，ios构建release包报错

答：请将cup架构设置为arm64，然后依次如下操作

- flutter clean
- flutter pub get
- cd ios
- pod install
- 连接真机后运行Archive

![ios cpu](https://user-images.githubusercontent.com/7018230/155913400-6231329a-aee9-4082-8d24-a25baad55261.png)

##### 7，ios运行的最低版本号？

答：11.0
