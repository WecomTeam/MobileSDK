//
//  AppDelegate.m
//  wxworksdktest
//
//  Created by WXWork on 16/5/25.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "WWKApi.h"

@interface AppDelegate () <WWKApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*! @brief 调用这个方法前需要先到管理端进行注册 走管理端的注册方式
     *
     * 在管理端通过注册(可能需要等待审批)，获得schema+corpid+agentid
     * 将获取到的三个参数对应填在这里，并到项目 Target 的 Info 里边注册 URL Types
     *
     * @param appId   第三方App的Schema
     * @param corpId  第三方App所属企业的ID
     * @param agentId 第三方App在企业内部的ID
     */
    [WWKApi registerApp:@"wxworksdktest" corpId:@"wx4bed5325e7819482" agentId:@""];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handleOpenURL:url sourceApplication:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    /*! @brief 处理外部调用URL的时候需要将URL传给SDK进行相关处理
     * @param url 外部调用传入的url
     * @param delegate 当前类需要实现WWKApiDelegate对应的方法
     */
    return [WWKApi handleOpenURL:url delegate:self];
}

- (void)onResp:(WWKBaseResp *)resp {
    /*! @brief 所有通过sendReq发送的SDK请求的结果都在这个函数内部进行异步回调
     * @param resp SDK处理请求后的返回结果 需要判断具体是哪项业务的回调
     */
    NSMutableString *extra = [NSMutableString string];
    
    /* 选择联系人的回调 */
    if ([resp isKindOfClass:[WWKPickContactResp class]]) {
        WWKPickContactResp *r = (WWKPickContactResp *)resp;
        for (int i = 0; i < MIN(r.contacts.count, 5); ++i) {
            if (extra.length) [extra appendString:@"\n"];
            [extra appendFormat:@"%@<%@>", [r.contacts[i] name], [r.contacts[i] email]];
        }
        if (r.contacts.count > 5) {
            [extra appendString:@"\n…"];
        }
    }
    
    /* SSO的回调 */
    if ([resp isKindOfClass:[WWKSSOResp class]]) {
        WWKSSOResp *r = (WWKSSOResp *)resp;
        [extra appendFormat:@"%@ for %@", r.code, r.state];
    }
    
    if (extra.length) [extra insertString:@"\n\n" atIndex:0];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"返回结果" message:[NSString stringWithFormat:@"错误码：%d\n错误信息：%@%@", resp.errCode, resp.errStr, extra] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

@end
