//
//  MainViewController.m
//  Channel
//
//
// 1.原生push进入flutter页面
// 2.原生present进入flutter页面
// 3.原生调用flutter方法
// 4.原生传值flutter   字符串、数组、字典、字典数组
// 5.flutter调用原生方法
// 6.flutter传值原生

#import "MainViewController.h"
#import <Flutter/Flutter.h>
#import "NativeFlutterVC.h"
#import "NativeSecondVC.h"
@interface MainViewController ()

@property (nonatomic, strong) FlutterViewController *flutterPresentVC;
@property (nonatomic, strong) NativeFlutterVC *flutterPushVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
}

- (IBAction)btnpresent:(id)sender {

    self.flutterPresentVC = [[FlutterViewController alloc] init];
    [self.flutterPresentVC setInitialRoute:@"PresentAppPage"];
    [self presentViewController:self.flutterPresentVC animated:false completion:nil];
    
    FlutterMethodChannel *presentChannel = [FlutterMethodChannel methodChannelWithName:@"qd.flutter.io/qd_PresentApp" binaryMessenger:self.flutterPresentVC];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(presentChannel) wsChannel = presentChannel;
    
    
    // 注册方法等待flutter页面调用
    [presentChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"回调的方法是：%@", call.method);
        NSLog(@"回传结果是：%@", result);
        
        if ([call.method isEqualToString:@"getNativeResult"]) {
            NSString *name = @"新年快乐";
            if (name == nil) {
                FlutterError *error = [FlutterError errorWithCode:@"UNAVAILABLE" message:@"Device info unavailable" details:nil];
                result(error);
            } else {
                result(name);
            }
            // 原生调用Flutter方法，带参数, 接收回传结果
            NSArray *arr = @[@{@"UserName":@"钟无艳",@"Age":@"12"},
                             @{@"UserName":@"诸葛亮",@"Age":@"52"}];
            [wsChannel invokeMethod:@"flutterMedia" arguments:arr result:^(id  _Nullable result) {
                NSLog(@"%@", result);
            }];
            
            [wsChannel invokeMethod:@"other" arguments:nil];

            
        } else if ([call.method isEqualToString:@"dismiss"]) {
           
            [weakSelf.flutterPresentVC dismissViewControllerAnimated:YES completion:nil];
            
        } else if ([call.method isEqualToString:@"gotoNativeSecondPage"]) {
            
            NativeSecondVC *secondVC = [[NativeSecondVC alloc] init];
            [self.flutterPresentVC presentViewController:secondVC animated:YES completion:nil];
        }else if ([call.method isEqualToString:@"showAlertView"]) {
           
            [weakSelf showAlertView];
        }else if ([call.method isEqualToString:@"callNativeMethond"]) {
          
            [weakSelf callNativeMethond:call.arguments];
        }else
        {
            result(FlutterMethodNotImplemented);
        }
    }];
}



- (IBAction)btn2:(id)sender
{
    self.flutterPushVC = [[NativeFlutterVC alloc] init];
    [self.flutterPushVC setInitialRoute:@"PushAppPage"];

    [self.navigationController pushViewController:self.flutterPushVC animated:true];
}





/** flutter调用原生并传值*/
- (void)callNativeMethond:(NSString *)string
{
    [self showAlertViewWithMessage:string title:@"flutter调用原生 - 传值"];
}

- (void)showAlertView
{
    [self showAlertViewWithMessage:@"调用原生UIAlertController弹窗" title:@"flutter调用原生 - 无传值"];
}



- (void)showAlertViewWithMessage:(NSString *)message title:(NSString *)title
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alertController addAction:okAction];
    // 3.呈现UIAlertContorller
    [self.flutterPresentVC presentViewController:alertController animated:YES completion:nil];
}

@end
