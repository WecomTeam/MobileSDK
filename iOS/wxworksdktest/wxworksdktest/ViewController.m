//
//  ViewController.m
//  wxworksdktest
//
//  Created by WXWork on 16/5/25.
//  Copyright © 2016年 tencent. All rights reserved.
//


#import "ViewController.h"
#import "WWKApi.h"

extern NSString *WWKAPP_SCHEME;

typedef NS_ENUM(NSInteger, WWKApiRole) {
    WWKApiRolePersonal,
    WWKApiRoleCorp,
    WWKApiRoleServiceProvider
};

typedef NS_ENUM(NSInteger, WWKApiFunction) {
    WWKApiSSO,
    WWKApiShareText,
    WWKApiShareFile,
    WWKApiShareImage,
    WWKApiShareVideo,
    WWKApiShareLink,
    WWKApiShareForward,
    WWKApiPickContact
};

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NSNumber *> *functions;
@end

@interface ActionCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.functions = [self roleFunctions:WWKApiRolePersonal];
    self.tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    cell.label.text = [self actionTitle:(WWKApiFunction)self.functions[indexPath.row].integerValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch ((WWKApiFunction)self.functions[indexPath.row].integerValue) {
        case WWKApiSSO:
            [self SSO:tableView];
            break;
        case WWKApiShareText:
            [self shareText:tableView];
            break;
        case WWKApiShareFile:
            [self shareFile:tableView];
            break;
        case WWKApiShareImage:
            [self shareImage:tableView];
            break;
        case WWKApiShareVideo:
            [self shareVideo:tableView];
            break;
        case WWKApiShareLink:
            [self shareLink:tableView];
            break;
        case WWKApiShareForward:
            [self shareForward:tableView];
            break;
        case WWKApiPickContact:
            [self pickContact:tableView];
            break;
    }
}

- (IBAction)roleSelect:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择应用类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"个人应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.functions = [self roleFunctions:WWKApiRolePersonal];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"企业应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.functions = [self roleFunctions:WWKApiRoleCorp];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"服务商应用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.functions = [self roleFunctions:WWKApiRoleServiceProvider];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)schemeSelect:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择企业微信版本" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"通用版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WWKAPP_SCHEME = @"wxwork";
    }]];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wxworklocal:"]]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"本地版本" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WWKAPP_SCHEME = @"wxworklocal";
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)actionTitle:(WWKApiFunction)func {
    switch (func) {
        case WWKApiSSO:
            return @"SSO";
        case WWKApiShareText:
            return @"分享文本";
        case WWKApiShareFile:
            return @"分享文件";
        case WWKApiShareImage:
            return @"分享图片";
        case WWKApiShareVideo:
            return @"分享视频";
        case WWKApiShareLink:
            return @"分享链接";
        case WWKApiShareForward:
            return @"分享聊天记录";
        case WWKApiPickContact:
            return @"选择邮箱联系人";
        default:
            return @"";
    }
}

- (NSArray<NSNumber *> *)roleFunctions:(WWKApiRole)role {
    switch (role) {
        case WWKApiRolePersonal:
            return @[
                @(WWKApiShareText),
                @(WWKApiShareFile),
                @(WWKApiShareImage),
                @(WWKApiShareVideo),
                @(WWKApiShareLink),
                @(WWKApiShareForward),
            ];
        case WWKApiRoleCorp:
            return @[
                @(WWKApiSSO),
                @(WWKApiShareText),
                @(WWKApiShareFile),
                @(WWKApiShareImage),
                @(WWKApiShareVideo),
                @(WWKApiShareLink),
                @(WWKApiShareForward),
                @(WWKApiPickContact)
            ];
        case WWKApiRoleServiceProvider:
            return @[
                @(WWKApiSSO),
                @(WWKApiShareText),
                @(WWKApiShareFile),
                @(WWKApiShareImage),
                @(WWKApiShareVideo),
                @(WWKApiShareLink),
                @(WWKApiShareForward),
                @(WWKApiPickContact)
            ];
    }
    return @[];
}

/*! @brief 分享文字 */
- (IBAction)shareText:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageTextAttachment *attachment = [[WWKMessageTextAttachment alloc] init];
    attachment.text = @"企业微信提供了通讯录管理、应用管理、消息推送、身份验证、移动端SDK、素材、OA数据接口、企业支付、电子发票等API，管理员可以使用这些API，为企业接入更多个性化的办公应用。";
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享文件 */
- (IBAction)shareFile:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageFileAttachment *attachment = [[WWKMessageFileAttachment alloc] init];
    attachment.filename = @"Download.pdf";
    attachment.path = [[NSBundle mainBundle] pathForResource:@"About Downloads" ofType:@"pdf"];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享图片 */
- (IBAction)shareImage:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageImageAttachment *attachment = [[WWKMessageImageAttachment alloc] init];
    attachment.filename = @"test.gif";
    attachment.path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享小视频 */
- (IBAction)shareVideo:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageVideoAttachment *attachment = [[WWKMessageVideoAttachment alloc] init];
    attachment.filename = @"video.mp4";
    attachment.path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 分享链接 */
- (IBAction)shareLink:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageLinkAttachment *attachment = [[WWKMessageLinkAttachment alloc] init];
    attachment.title = @"链接标题";
    attachment.summary = @"链接介绍";
    attachment.url = @"http://www.tencent.com";
    attachment.icon = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 转发 */
- (IBAction)shareForward:(id)sender {
    WWKSendMessageReq *req = [[WWKSendMessageReq alloc] init];
    WWKMessageGroupAttachment *attachment = [[WWKMessageGroupAttachment alloc] init];
    attachment.title = @"XXX的聊天记录";
    NSMutableArray *array = [NSMutableArray array];

    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小明";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-1000];
        wrapper.avatarUrl = @"http://p.qlogo.cn/bizmail/BDHWBviaRjEgxSn7E5dBwXMM0bibQVVFXe6C6dhtAdsGMu7vL7AuNpIQ/100";
        wrapper.attachment = ({
            WWKMessageTextAttachment *text = [[WWKMessageTextAttachment alloc] init];
            text.text = @"关注你我健康";
            text;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小明";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-950];
        wrapper.avatarUrl = @"http://p.qlogo.cn/bizmail/BDHWBviaRjEgxSn7E5dBwXMM0bibQVVFXe6C6dhtAdsGMu7vL7AuNpIQ/100";
        wrapper.attachment = ({
            WWKMessageImageAttachment *image = [[WWKMessageImageAttachment alloc] init];
            image.filename = @"test.gif";
            image.path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
            image;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小明";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-930];
        wrapper.avatarUrl = @"http://p.qlogo.cn/bizmail/BDHWBviaRjEgxSn7E5dBwXMM0bibQVVFXe6C6dhtAdsGMu7vL7AuNpIQ/100";
        wrapper.attachment = ({
            WWKMessageLocationAttachment *loc = [[WWKMessageLocationAttachment alloc] init];
            loc.title = @"T.I.T创意园";
            loc.address = @"广东省广州市海珠区新港中路397号";
            loc.lat = 23.098837;
            loc.lng = 113.325119;
            loc;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-900];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageTextAttachment *text = [[WWKMessageTextAttachment alloc] init];
            text.text = @"学车找我不愁";
            text;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-850];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageFileAttachment *file = [[WWKMessageFileAttachment alloc] init];
            file.filename = @"Download.pdf";
            file.path = [[NSBundle mainBundle] pathForResource:@"About Downloads" ofType:@"pdf"];
            file;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-850];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageVideoAttachment *video = [[WWKMessageVideoAttachment alloc] init];
            video.filename = @"video.mp4";
            video.path = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
            video;
        });
        wrapper;
    })];
    
    [array addObject:({
        WWKMessageAttachmentWrapper *wrapper = [[WWKMessageAttachmentWrapper alloc] init];
        wrapper.name = @"小码";
        wrapper.date = [[NSDate date] dateByAddingTimeInterval:-800];
        wrapper.avatarData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
        wrapper.attachment = ({
            WWKMessageLinkAttachment *link = [[WWKMessageLinkAttachment alloc] init];
            link.title = @"链接标题";
            link.summary = @"链接介绍";
            link.url = @"http://www.tencent.com";
            link.icon = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon" ofType:@"jpg"]];
            link;
        });
        wrapper;
    })];
    
    attachment.contents = array;
    req.attachment = attachment;
    [WWKApi sendReq:req];
}

/*! @brief 选择联系人 */
- (IBAction)pickContact:(id)sender {
    WWKPickContactReq *req = [[WWKPickContactReq alloc] init];
    req.type = @"mail";
    [WWKApi sendReq:req];
}

/*! @brief SSO */
- (IBAction)SSO:(id)sender {
    WWKSSOReq *req = [[WWKSSOReq alloc] init];
    req.state = @"adfasdfasdf23412341fqw4df14t134rtflajssf8934haioefy";
    [WWKApi sendReq:req];
}

@end

@implementation ActionCell

@end
