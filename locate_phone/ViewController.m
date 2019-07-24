//
//  ViewController.m
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/24.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import "ViewController.h"
#import <sys/utsname.h>
#import "GXCButtonFrame.h"




@interface ViewController ()
@property (strong, nonatomic) UIButton *phone_status;
@property (strong, nonatomic) UIButton *phone_borrow;
@property (strong, nonatomic) UIButton *phone_back;
@property (strong, nonatomic) UILabel *phone_status_label;
@property (strong, nonatomic) UILabel *phone_borrow_label;
@property (strong, nonatomic) UILabel *phone_back_label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GXCButtonFrame *gxcButtonFrame = [[GXCButtonFrame alloc] init];
    self.phone_status = [gxcButtonFrame SetButtonFrame:@"" image:@"status@2x" index:1];
    [self.phone_status addTarget:self action:@selector(tap_status) forControlEvents:UIControlEventTouchUpInside];
    self.phone_status_label = [gxcButtonFrame SetLabelFrame:@"查" size:24 index:1];
    self.phone_borrow = [gxcButtonFrame SetButtonFrame:@"" image:@"borrow@2x" index:2];
    self.phone_borrow_label = [gxcButtonFrame SetLabelFrame:@"借" size:24 index:2];
    self.phone_back = [gxcButtonFrame SetButtonFrame:@"" image:@"back@2x" index:3];
    self.phone_back_label = [gxcButtonFrame SetLabelFrame:@"还" size:24 index:3];
    [self.view addSubview:self.phone_status];
    [self.view addSubview:self.phone_status_label];
    [self.view addSubview:self.phone_borrow];
    [self.view addSubview:self.phone_borrow_label];
    [self.view addSubview:self.phone_back];
    [self.view addSubview:self.phone_back_label];
    
    
    
//
//    UIDevice *myDecive = [UIDevice currentDevice];
//    NSString *platform = [self platform];
//
//    [self.view addSubview:[self drawRect]];
//    self.text_device =  [[UITextView alloc] initWithFrame: CGRectMake(80, 100, 400, 200)];
//    self.text_device.font = [UIFont fontWithName:@"Arial" size:18.0]; //设置字体名字和字体大小;
//    device_info = [myDecive.name stringByAppendingString:myDecive.model];
    

//    self.text_device.text = device_info;
//    [self.view addSubview:self.text_device];
    
//    self.button = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 120, 30)];
//    [self.button setTitle:@"点我" forState:UIControlStateNormal];
//    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap_status {
    NSString* device_info = [self get_device_info];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设备信息" message:device_info preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(alertController) weakAlert = alertController;
    
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //为了防止循环引用，在这里需要进行弱引用设置，下面如果有用到alertController的也需要做相同的处理
        NSString *text = weakAlert.textFields.lastObject.text;
        NSLog(@"%@",text);
    }];
    [alertController addAction:actionDefault];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
//    self.label.text = ([self.label.text isEqualToString:HELLO_EN])?HELLO_ZH:HELLO_EN;
}

- (NSString *)get_device_info{
    NSString *platform = [self platform];
    UIDevice *myDecive = [UIDevice currentDevice];
    NSString *name = [[NSString alloc] init];
    name = myDecive.name;
    NSString *sysversion = [[NSString alloc] init];
    sysversion = myDecive.systemVersion;
    
    NSString *device_info = [NSString stringWithFormat:@"名字:%@\n平台:%@\n系统版本:%@",name, platform, sysversion];
    return device_info;
}

- (NSString *)platform
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
