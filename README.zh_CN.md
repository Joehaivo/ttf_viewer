# TTF Viewer

> 一个用于浏览TrueType字体(.ttf)文件(通常叫iconfont)内图标的开源跨平台应用程序, 采用Flutter编写.

> Language: [简体中文](README.zh_CN.md) [English](README.md)

## 1. 应用功能

- 支持拖放ttf文件到应用窗口内来浏览, 支持批量拖放. (手机端除外)
- 支持同时打开多个字体文件
- 支持通过图标关键字来搜索过滤
- 支持复制字体内所有的字形代码(JSON), 方便编程
- 支持改变图标颜色
- 支持自动跟随系统切换语言（中文和英文）
- 支持多平台

| Android | iOS  |                      WEB                      | MacOS | Windows | Linux |
| :-----: | :--: | :-------------------------------------------: | :---: | :-----: | :---: |
|    ✅    |  ⚠️   | ✅ [Go](https://Joehaivo.github.io/ttf_viewer) |   ✅   |    ✅    |   ✅   |

> iOS: 由于商店限制较多,上架较为麻烦,暂未考虑,可自行编译运行


## 2. 应用截图

- 浏览TTF文件内图标

| <img src="./doc/screenshot/image-20230118111747182.png" alt="image-20230118134418925" style="zoom:60%;" /> | <img src="./doc/screenshot/WechatIMG90.jpeg" alt="WechatIMG90" style="zoom: 18%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |

- 图标搜索

| <img src="./doc/screenshot/image-20230118112618519.png" alt="image-20230118134610113" style="zoom:60%;" /> | <img src="./doc/screenshot/WechatIMG91.jpeg" alt="WechatIMG91" style="zoom:18%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |



- 字体信息/图标颜色

| <img src="./doc/screenshot/image-20230118112553371.png" alt="image-20230118134847227" style="zoom:60%;" /> | <img src="./doc/screenshot/WechatIMG92.jpeg" alt="WechatIMG92" style="zoom:18%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ |



## 3. 应用下载

- [web在线网站](https://Joehaivo.github.io/ttf_viewer)

- [release下载页](https://github.com/Joehaivo/ttf_viewer/releases)

- [ttf示例文件](doc/iconfont.ttf)

## 4. 编译运行

> flutter 版本: Flutter (Channel stable, 3.3.5), Dart version 2.18.2, 运行`flutter doctor -v` 查看

1. 克隆项目

```shell
git clone https://github.com/Joehaivo/ttf_viewer
```

2. 进入工作目录

```shell
cd ttf_viewer
```

3. 列出当前支持的平台

```shell
flutter devices
```

运行后会打印如下信息:

> 3 connected devices:
>
> 22041211AC (mobile) • A6I7PNQC8X45WGXK • android-arm64  • Android 13 (API 33)
>
> macOS (desktop)     • macos            • darwin-arm64   • macOS 13.0.1 22A400 darwin-arm
>
> Chrome (web)        • chrome           • web-javascript • Google Chrome 109.0.5414.87

4. 选择在合适的平台调试运行

```shell
flutter run -d 22041211AC # 运行在Android设备上, 22041211AC来自上一步
# flutter run -d macOS # 运行在macOS设备上
```

5. 打包

```shell
flutter build apk --no-tree-shake-icons # Android, 产物在 build/app/outputs/apk/release/app-release.apk
# flutter build macos --no-tree-shake-icons # macOS, 产物在 build/macos/Build/Products/Release/TTF Viewer.app
# fluteer build web # web, 产物在 build/web, 将其web下的内容部署到nginx即可
```

- 5.1 *可选步骤*: 在macOS平台将TTF Viewer.app打包成TTF Viewer.dmg

```shell
npm install -g appdmg # 需要先安装好node和npm
cd installers/dmg_creator
appdmg config.json ../../build/macos/Build/Products/Release/TTF\ Viewer.dmg
```