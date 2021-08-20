# MobileSDK 企业微信移动端SDK资源
Wecom Mobile SDK 企业微信移动端 SDK。

## iOS资源下载

本目录包含iOS开发工具包集合（0.16版本）
1. `WWKApi.h` 定义SDK接口的头文件
2. `WWKObject.h` 定义SDK接口用来进行参数传递的对象
3. `libWXWorkApi.a` 第三方工程需要引用的SDK静态库文件
4. `wxworksdktest/` 一个供参考的企业微信iOS端SDK使用的示例工程，这个工程介绍了当前版本SDK提供的所有接口的使用方法

## Android资源下载

开发 SDK、签名工具以及 Demo，使用企业微信登录、分享功能需要用到文件如下。
1. Android开发工具包集合 `lib_wwapi-2.0.12.6.aar`，每个第三方应用必须要导入该SDK库，用于实现与企业微信的通信
2. 签名生成工具 `Gen_Signature_Android.apk`，安装此工具，根据指引生成的应用签名字符串并填写在应用管理平台上，未填写或者填写错误将导致接口无法使用。
3. 接口使用 Demo `apitest/`。开发者可以参考Demo中的接口使用方式进行开发。
4. 
