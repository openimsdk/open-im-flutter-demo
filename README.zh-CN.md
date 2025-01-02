<p align="center">
    <a href="https://openim.io">
        <img src="./docs/images/logo.jpg" width="60%" height="30%"/>
    </a>
</p>

# OpenIM Flutter 💬💻

<p>
  <a href="https://docs.openim.io/">OpenIM Docs</a>
  •
  <a href="https://github.com/openimsdk/open-im-server">OpenIM Server</a>
  •
  <a href="https://github.com/openimsdk/openim-sdk-js-wasm">openim-sdk-wasm</a>
  •
  <a href="https://github.com/openimsdk/openim-sdk-electron">openim-sdk-electron</a>
  •
  <a href="https://github.com/openimsdk/openim-sdk-core">openim-sdk-core</a>
</p>
OpenIM 为开发者提供开源即时通讯 SDK，作为 Twilio、Sendbird 等云服务的替代方案。借助 OpenIM，开发者可以构建安全可靠的即时通讯应用，如 WeChat、Zoom、Slack 等。

本仓库基于开源版 OpenIM SDK 开发，提供了一款基于 Flutter 的即时通讯应用。您可以使用此应用程序作为 OpenIM SDK 的参考实现。

<p align="center">
    <img src="./docs/images/preveiw1.zh-CN.jpeg" alt="预览图" width="32%"/>
    <span style="display: inline-block; width: 16px;"></span>
    <img src="./docs/images/preveiw2.zh-CN.jpeg" alt="预览图" width="32%"/>
</p>

## 授权许可 :page_facing_up:

本仓库采用 GNU Affero 通用公共许可证第 3 版 (AGPL-3.0) 进行许可，并受以下附加条款的约束。**不允许用于商业用途**。详情请参阅 [此处](./LICENSE)。

## 开发环境

在开始开发之前，请确保您的系统已安装以下软件：

- **操作系统**：macOS 14.6 或更高版本
- **Flutter**：版本 3.24.5（根据官网步骤进行[安装](https://docs.flutter.cn/get-started/install)）
- **Git**：用于代码版本控制

同时，您需要确保已经[部署](https://docs.openim.io/zh-Hans/guides/gettingStarted/dockerCompose)了最新版本的 OpenIM Server。接下来，您可以编译项目并连接自己的服务端进行测试。

## 运行环境

本应用支持以下操作系统版本：

| 操作系统 | 版本              | 状态 |
| --------------- | ----------------- | ---- |
| **iOS**      | 13.0 及以上         | ✅   |
| **Android**     | minSdkVersion 24 | ✅   |

### 说明

- **Flutter**：确保您的版本符合要求，以避免依赖问题。

## 快速开始

按照以下步骤设置本地开发环境：

1. 拉取代码

```bash
  git clone https://github.com/openimsdk/open-im-flutter-demo.git
  cd open-im-flutter-demo
```

2. 安装依赖

```bash
  flutter clean 
  flutter pub get
```

3. 修改配置

  > 如果没有修改过服务端默认端口，则只需要修改[_host](https://github.com/openimsdk/open-im-flutter-demo/blob/a309f25fdbc143e49d5ca852171ce57970871c85/openim_common/lib/src/config.dart#L59)为您的服务器 ip 即可。

  ```dart
    static const _host = "your-server-ip/domain";
  ```

4. 通过终端执行 `flutter run` 或者IDE的启动菜单来运行iOS/Android应用程序。

5. 开始开发测试！ 🎉

## 音视频通话

开源版支持一对一音视频通话，并且需要先部署并配置[服务端](https://github.com/openimsdk/chat/blob/main/HOW_TO_SETUP_LIVEKIT_SERVER.md)。多人音视频通话、视频会议请联系邮箱 [contact@openim.io](mailto:contact@openim.io)

## 构建 🚀

> 该项目允许分别构建 iOS 应用程序和 Android 应用程序，但在构建过程中会有一些差异。

   - iOS:
     ```bash
     flutter build ipa
     ```
   - Android:
     ```bash
     flutter build apk
     ```

 构建结果将位于 `build`  目录下。

## 功能列表

### 说明

| 功能模块           | 功能项                                                    | 状态 |
| ------------------ | --------------------------------------------------------- | ---- |
| **账号功能**       | 手机号注册\邮箱注册\验证码登录                            | ✅   |
|                    | 个人信息查看\修改                                         | ✅   |
|                    | 多语言设置                                                | ✅   |
|                    | 修改密码\忘记密码                                         | ✅   |
| **好友功能**       | 查找\申请\搜索\添加\删除好友                              | ✅   |
|                    | 同意\拒绝好友申请                                         | ✅   |
|                    | 好友备注                                                  | ✅   |
|                    | 是否允许添加好友                                          | ✅   |
|                    | 好友列表\好友资料实时同步                                 | ✅   |
| **黑名单功能**     | 限制消息                                                  | ✅   |
|                    | 黑名单列表实时同步                                        | ✅   |
|                    | 添加\移出黑名单                                           | ✅   |
| **群组功能**       | 创建\解散群组                                             | ✅   |
|                    | 申请加群\邀请加群\退出群组\移除群成员                     | ✅   |
|                    | 群名/群头像更改/群资料变更通知和实时同步                  | ✅   |
|                    | 群成员邀请进群                                            | ✅   |
|                    | 群主转让                                                  | ✅   |
|                    | 群主、管理员同意进群申请                                  | ✅   |
|                    | 搜索群成员                                                | ✅   |
| **消息功能**       | 离线消息                                                  | ✅   |
|                    | 漫游消息                                                  | ✅   |
|                    | 多端消息                                                  | ✅   |
|                    | 历史消息                                                  | ✅   |
|                    | 消息删除                                                  | ✅   |
|                    | 消息清空                                                  | ✅   |
|                    | 消息复制                                                  | ✅   |
|                    | 单聊正在输入                                              | ✅   |
|                    | 新消息勿扰                                                | ✅   |
|                    | 清空聊天记录                                              | ✅   |
|                    | 新成员查看群聊历史消息                                    | ✅   |
|                    | 新消息提示                                                | ✅   |
|                    | 文本消息                                                  | ✅   |
|                    | 图片消息                                                  | ✅   |
|                    | 视频消息                                                  | ✅   |
|                    | 表情消息                                                  | ✅   |
|                    | 文件消息                                                  | ✅   |
|                    | 语音消息                                                  | ✅   |
|                    | 名片消息                                                  | ✅   |
|                    | 地理位置消息                                              | ✅   |
|                    | 自定义消息                                                | ✅   |
| **会话功能**       | 置顶会话                                                  | ✅   |
|                    | 会话已读                                                  | ✅   |
|                    | 会话免打扰                                                | ✅   |
| **REST API**       | 认证管理                                                  | ✅   |
|                    | 用户管理                                                  | ✅   |
|                    | 关系链管理                                                | ✅   |
|                    | 群组管理                                                  | ✅   |
|                    | 会话管理                                                  | ✅   |
|                    | 消息管理                                                  | ✅   |
| **Webhook**        | 群组回调                                                  | ✅   |
|                    | 消息回调                                                  | ✅   |
|                    | 推送回调                                                  | ✅   |
|                    | 关系链回调                                                | ✅   |
|                    | 用户回调                                                  | ✅   |
| **容量和性能**     | 1 万好友                                                  | ✅   |
|                    | 10 万人大群                                               | ✅   |
|                    | 秒级同步                                                  | ✅   |
|                    | 集群部署                                                  | ✅   |
|                    | 互踢策略                                                  |      |
| **在线状态**       | 所有平台不互踢                                            | ✅   |
|                    | 每个平台各只能登录一个设备                                | ✅   |
|                    | PC 端、移动端、Pad 端、Web 端、小程序端各只能登录一个设备 | ✅   |
|                    | PC 端不互踢，其他平台总计一个设备                         | ✅   |
| **音视频通话**     | 一对一音视频通话                                          | ✅   |
| **文件类对象存储** | 支持私有化部署 minio                                      | ✅   |
|                    | 支持 COS、OSS、Kodo、S3 公有云                            | ✅   |
| **推送**           | 消息在线实时推送                                          | ✅   |
|                    | 消息离线推送，支持个推，Firebase                          | ✅   |

更多高级功能、音视频通话、视频会议 请联系邮箱 [contact@openim.io](mailto:contact@openim.io)

## 加入社区 :busts_in_silhouette:

- 🚀 [加入我们的 Slack 社区](https://join.slack.com/t/openimsdk/shared_invite/zt-22720d66b-o_FvKxMTGXtcnnnHiMqe9Q)
- :eyes: [加入我们的微信群](https://openim-1253691595.cos.ap-nanjing.myqcloud.com/WechatIMG20.jpeg)

## 常见问题

##### 1. 是否支持多语言？
答：支持，默认跟随系统语言。

##### 2. 支持哪些平台？
答：目前 Demo 支持 Android 和 iOS。

##### 3. Android 安装包的 debug 版本可以运行，但 release 启动是白屏？
答：Flutter 的 release 包默认会进行混淆，可以使用以下命令：

```bash
  flutter build release --no-shrink
```

如果此命令无效，可以在 android/app/build.gradle 文件的 release 配置中添加以下代码：

```bash
  release {
      minifyEnabled false
      useProguard false
      shrinkResources false
  }
```

##### 4. 如果代码必须混淆该怎么办？
答：在混淆规则中添加以下配置：

```bash
  -keep class io.openim.**{*;}
  -keep class open_im_sdk.**{*;}
  -keep class open_im_sdk_callback.**{*;}
```

##### 5. Android 安装包无法安装在模拟器上？
答：由于 Demo 移除了一些 CPU 架构，如果需要在模拟器上运行，请在 android/build.gradle 配置中添加以下内容：

```bash
  ndk {
      abiFilters "armeabi-v7a",  "x86"
  }
```

##### 6. iOS 运行/打包 release 包时报错？
答：请将 CPU 架构设置为 arm64，然后按以下步骤操作：

```bash
  执行 flutter clean
  执行 flutter pub get
  cd ios/
  rm -f Podfile.lock
  rm -rf Pods
  执行 pod install
  连接真机后运行 Archive。
```
![ios cpu](https://user-images.githubusercontent.com/7018230/155913400-6231329a-aee9-4082-8d24-a25baad55261.png)

##### 7. iOS 最低运行版本是多少？
答：13.0
