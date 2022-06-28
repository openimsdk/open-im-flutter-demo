## 可以免费使用，必须在app启动页加上 (由OpenIM提供技术支持)

### OpenIM
A OpenIM flutter demo, only support android and ios.

![image](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/gif/QQ20211207-101110.gif)



### 官方demo使用

##### 1. 下载体验app

![Android](https://www.pgyer.com/app/qrcode/OpenIM)

##### 2. 替换服务器地址为自己搭建的服务器地址，默认地址为官方服务器地址

![image](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/gif/QQ20211216-141624.gif)


### 源代码使用

1. git clone https://github.com/OpenIMSDK/Open-IM-Flutter-Demo.git
2. 修改 [config.dart](https://github.com/OpenIMSDK/Open-IM-Flutter-Demo/blob/master/lib/src/common/config.dart)文件里的服务器地址为自己搭建的服务器地址
3. 运行flutter pub get
4. 运行flutter run

### 其他

demo里使用的ui库链接：[flutter_openim_widget ](https://github.com/hrxiang/flutter_openim_widget.git)

demo使用的im库链接：[flutter_openim_sdk ](https://github.com/OpenIMSDK/Open-IM-SDK-Flutter.git)

### Issues

##### 1，demo对应的flutter版本是？

答：stable分支3.0.1

##### 2，支持哪些平台？

答：因为sdk的原因demo目前只能运行在android跟ios设备上

##### 3，android安装包debug可以运行但release启动白屏？

答：flutter的release包默认是开启了混淆，可以使用命令：flutter build release --no -shrink，如果此命令无效可如下操作

在android/build.gradle配置的release配置加入以下配置

```
release {
    minifyEnabled false
    useProguard false
    shrinkResources false
}
```

##### 4，代码必须混淆怎么办？

答：在混淆规则里加入以下规则

```
-keep class io.openim.**{*;}
-keep class open_im_sdk.**{*;}
-keep class open_im_sdk_callback.**{*;}
```

##### 5，android安装包不能安装在模拟器上？

答：因为Demo去掉了某些cpu架构，如果你想运行在模拟器上请按以下方式：

在android/build.gradle配置加入

```
ndk {
    abiFilters "arm64-v8a", "armeabi-v7a", "armeabi", "x86", "x86_64"
}
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

答：13.0
