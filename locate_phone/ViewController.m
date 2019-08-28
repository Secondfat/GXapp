//
//  ViewController.m
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/24.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import "ViewController.h"
#import <sys/utsname.h>
#import "GXClocate_phone/GXCButtonFrame.h"
#import "GXClocate_phone/GXCAlert_Control.h"
#import "GXCHttp/GXCHttp.h"
#import "GXCDataController/Handle_local_data.h"


@interface ViewController ()

@property (strong, nonatomic) UIButton *phone_status;
@property (strong, nonatomic) UIButton *phone_borrow;
@property (strong, nonatomic) UIButton *phone_back;
@property (strong, nonatomic) UILabel *phone_status_label;
@property (strong, nonatomic) UILabel *phone_borrow_label;
@property (strong, nonatomic) UILabel *phone_back_label;
@property (strong, nonatomic) UIAlertAction *secureTextAlertAction;
@property (strong, nonatomic) NSString *phone_number;
@property (strong, nonatomic) NSString *belong_name;
@property BOOL bool_number;
@property BOOL bool_belong;

@end

NSString *ConnectIP = @"http://10.134.42.44:5700";
NSString *phone_info_port = @"/phone_info";
NSString *borrow_phone_port = @"/borrow_phone";
NSString *back_phone_port = @"/back_phone";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GXCButtonFrame *gxcButtonFrame = [[GXCButtonFrame alloc] init];
    self.phone_status = [gxcButtonFrame SetButtonFrame:@"" image:@"status@2x" index:1];
    [self.phone_status addTarget:self action:@selector(tap_status) forControlEvents:UIControlEventTouchUpInside];
    self.phone_status_label = [gxcButtonFrame SetLabelFrame:@"查" size:24 index:1];
    self.phone_borrow = [gxcButtonFrame SetButtonFrame:@"" image:@"borrow@2x" index:2];
    [self.phone_borrow addTarget:self action:@selector(tap_borrow) forControlEvents:UIControlEventTouchUpInside];
    self.phone_borrow_label = [gxcButtonFrame SetLabelFrame:@"借" size:24 index:2];
    self.phone_back = [gxcButtonFrame SetButtonFrame:@"" image:@"back@2x" index:3];
    [self.phone_back addTarget:self action:@selector(tap_back) forControlEvents:UIControlEventTouchUpInside];
    self.phone_back_label = [gxcButtonFrame SetLabelFrame:@"还" size:24 index:3];
    [self.view addSubview:self.phone_status];
    [self.view addSubview:self.phone_status_label];
    [self.view addSubview:self.phone_borrow];
    [self.view addSubview:self.phone_borrow_label];
    [self.view addSubview:self.phone_back];
    [self.view addSubview:self.phone_back_label];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"phone_number"] == nil) {
        [self performSelector:@selector(show_edit_phone:) withObject:nil afterDelay:0.0];
    } else{
        NSString *store_version = [[NSUserDefaults standardUserDefaults] objectForKey:@"sysversion"];
        NSString *current_version = [[[Handle_local_data alloc] init] get_current_version];
        if (![store_version isEqualToString:current_version] && ![self isBlankString:store_version] && ![self isBlankString:current_version] ) {
            GXCHttp *gxchttp = [[GXCHttp alloc]init];
            [self make_update_info: gxchttp op: @"change"];
            [gxchttp do_post:^(BOOL sucess, int state_code, NSString* err_reason) {
                if (sucess) {
                    if (state_code == 200) {
                        NSString *version = [NSString stringWithFormat:@"%@+%@", store_version, current_version];
                        [self performSelector:@selector(change_system:) withObject:version afterDelay:0.0];
                    } else {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"数据错误!" content:err_reason isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                        }];
                    }
                } else {
                    UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"数据错误!" content:err_reason isText:(BOOL) NO];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                }
            }];
        } else {
            NSLog(@"222");
            //            [[[Handle_local_data alloc] init] Get_phone_info];
            //            NSString *version = [NSString stringWithFormat:@"%@+%@", store_version, current_version];
            //            [self performSelector:@selector(change_system:) withObject:version afterDelay:0.0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tap_status {
    if ([self check_login]) {
        Handle_local_data *handle_local_data = [[Handle_local_data alloc] init];
        NSString* device_info = [handle_local_data Get_phone_info];
        UIAlertController *alertController = [self change_phone_info:@"设备信息" content:device_info];
        [self presentViewController:alertController animated:YES completion:^{
        }];
    } else {
        [self performSelector:@selector(show_edit_phone:) withObject:nil afterDelay:0.0];
    }
}

- (void) tap_borrow {
    if ([self check_login]) {
        Handle_local_data *handle_local_data = [[Handle_local_data alloc] init];
        NSString* device_info = [handle_local_data Get_phone_info];
        UIAlertController *alertController = [self alert_double:@"设备信息" content:device_info isText:YES];
        [self presentViewController:alertController animated:YES completion:^{
        }];
    } else {
        [self performSelector:@selector(show_edit_phone:) withObject:nil afterDelay:0.0];
    }
}

- (void) tap_back {
    if ([self check_login]) {
        if ([self check_state]) {
            UIAlertController *alertVC = [self alert_double:@"提示" content:@"确定归还手机吗？" isText:NO];
            [self presentViewController:alertVC animated:YES completion:nil];
        } else {
            GXCAlert_Control *gxcAlert_Control = [[GXCAlert_Control alloc] init];
            UIAlertController *alertVC = [gxcAlert_Control alert_title:@"提示" content:@"手机尚未借出！" isText:NO];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else {
        [self performSelector:@selector(show_edit_phone:) withObject:nil afterDelay:0.0];
    }
}

- (void) change_system: (NSString *)version_combine {
    NSArray *array = [version_combine componentsSeparatedByString:@"+"];
    NSString *content = [NSString stringWithFormat:@"手机版本已由%@升级到%@", array[0], array[1]];
    UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"设备信息" content:content isText:(BOOL) NO];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

- (UIAlertController*) alert_double :(NSString *)title content:(NSString *)content isText:(BOOL)istext {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    if (istext) {
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * nameField) {
            nameField.placeholder = @"请输入借用者的名字";
            [nameField addTarget:self action:@selector(changedTextField_number:) forControlEvents:UIControlEventEditingChanged];
        }];
    }
    GXCHttp* gxchttp = [[GXCHttp alloc] init];
    gxchttp.dict = [NSMutableDictionary new];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *comfirmAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (istext) {
            gxchttp.ip_addr = [ConnectIP stringByAppendingString:borrow_phone_port];
            NSString *borrow_name = alertVC.textFields.firstObject.text;
            NSString *borrow_time = [self getNowTimeTimestamp];
            NSString *state = [userDefault objectForKey:@"state"];
            [gxchttp.dict removeAllObjects];
            [gxchttp.dict setObject:[userDefault objectForKey:@"phone_number"] forKey:@"phone_number"];
            [gxchttp.dict setObject:[userDefault objectForKey:@"sys_version"] forKey:@"borrow_version"];
            [gxchttp.dict setObject:[userDefault objectForKey:@"state"] forKey:@"state"];
            if ([state isEqualToString:@"1"]) {
                [gxchttp.dict setObject:[userDefault objectForKey:@"dur_day"] forKey:@"dur_day"];
                [gxchttp.dict setObject:[userDefault objectForKey:@"borrow_name"] forKey:@"back_name"];
                [gxchttp.dict setObject:[userDefault objectForKey:@"model"] forKey:@"model"];

            }
            [gxchttp.dict setObject:borrow_name forKey:@"borrow_name"];
            [gxchttp.dict setObject:borrow_time forKey:@"borrow_time"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"湖北省武汉市" forKey:];
            NSLog(@"%@", borrow_name);
            [gxchttp do_post:^(BOOL success, int state_code, NSString* err_reason) {
                if (success) {
                    //点击确定要执行的代码
                    if (state_code == 200) {
                        UIAlertController *alertController1 = [[[GXCAlert_Control alloc] init] alert_title:@"借出成功!" content:@"友情提示：请勿擅自升级系统\n谢谢合作！" isText:(BOOL) NO];
                        [self presentViewController:alertController1 animated:YES completion:^{
                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                            [userDefault setObject:borrow_name forKey:@"borrow_name"];
                            [userDefault setObject:@"1" forKey:@"state"];
                            [userDefault setObject:borrow_time forKey:@"borrow_time"];
                            [userDefault synchronize];
                        }];
                    } else if (state_code == -1) {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"数据错误!" content:err_reason isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                        }];
                    }
                } else {
                    UIAlertController *alertController1 = [[[GXCAlert_Control alloc] init] alert_title:@"失败" content:@"请重试，若再次失败，请联系APP测试组查看" isText:(BOOL) NO];
                    [self presentViewController:alertController1 animated:YES completion:^{
//                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                        [userDefault setObject:borrow_name forKey:@"borrow_name"];
//                        [userDefault setObject:@"1" forKey:@"state"];
//                        [userDefault setObject:borrow_time forKey:@"borrow_time"];
//                        [userDefault synchronize];
                    }];
                }
            }];
        } else {
            gxchttp.ip_addr = [ConnectIP stringByAppendingString:back_phone_port];
            NSString *back_time = [self getNowTimeTimestamp];
            int dur_day = ([back_time intValue] - [[userDefault objectForKey:@"borrow_time"] intValue]) / 86400 + 1;
            [gxchttp.dict removeAllObjects];
            [gxchttp.dict setObject:[userDefault objectForKey:@"phone_number"] forKey:@"phone_number"];
            [gxchttp.dict setObject:[userDefault objectForKey:@"sys_version"] forKey:@"back_version"];
            [gxchttp.dict setObject:[userDefault objectForKey:@"borrow_name"] forKey:@"borrow_name"];
//            [gxchttp.dict setObject:@"12.2.2" forKey:@"back_version"];
            [gxchttp.dict setObject:[userDefault objectForKey:@"state"] forKey:@"state"];
            [gxchttp.dict setObject:[NSString stringWithFormat:@"%d", dur_day] forKey:@"dur_day"];
            [gxchttp.dict setObject:back_time forKey:@"back_time"];
            [gxchttp.dict setObject:@"1" forKey:@"isiOS"];
            [gxchttp do_post:^(BOOL sucess, int state_code, NSString* err_reason) {
                if (sucess) {
                    if (state_code == 200) {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"归还成功!" content:@"" isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                            [userDefault removeObjectForKey:@"borrow_name"];
                            [userDefault removeObjectForKey:@"borrow_time"];
                            [userDefault removeObjectForKey:@"dur_day"];
                            [userDefault setObject:@"0" forKey:@"state"];
                            [userDefault synchronize];
                        }];
                    } else if (state_code == -1) {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"数据错误!" content:err_reason isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                            }];
                    }
                } else {
                    UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"归还失败!" content:@"" isText:(BOOL) NO];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                }
            }];
        }
    }];
    if (istext) {
        comfirmAc.enabled = NO;
        self.secureTextAlertAction = comfirmAc;
        self.bool_belong = YES;
    } else {
        comfirmAc.enabled = YES;
    }
    
    
    [alertVC addAction:cancelAc];
    [alertVC addAction:comfirmAc];
    return alertVC;
}

- (UIAlertController*) change_phone_info :(NSString *)title content:(NSString *)content {
    UIAlertController *alertCI = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelCI = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    //借出时不允许修改信息 暂时关闭修改入口
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] isEqualToString:@"0"]) {
        UIAlertAction *comfirmCI = [UIAlertAction actionWithTitle:@"同步" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            GXCHttp *gxchttp = [[GXCHttp alloc]init];
            [self make_update_info:gxchttp op:@"change"];
            [gxchttp do_post:^(BOOL sucess, int state_code, NSString* err_reason) {
                if (sucess) {
                    if (state_code == 200) {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"手机信息同步成功!" content:@"" isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                        }];
                    } else if (state_code == -1) {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"数据错误!" content:err_reason isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                        }];
                    }
                } else {
                    if (state_code == -1) {
                        UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"手机信息同步失败!" content:@"" isText:(BOOL) NO];
                        [self presentViewController:alertController animated:YES completion:^{
                        }];
                    }
                }
            }];
        }];
    [alertCI addAction:comfirmCI];
    }
    [alertCI addAction:cancelCI];
    return alertCI;
}
    
    

- (void) show_edit_phone: (NSString *)type {
    NSString *title = NSLocalizedString(@"请填写手机必要信息", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *NumberField) {
        NumberField.placeholder = @"请输入此手机的编号";
        self.bool_number = NO;
        [NumberField addTarget:self action:@selector(changedTextField_number:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *BelongField) {
        BelongField.placeholder = @"请输入此手机的负责人";
        self.bool_belong = NO;
        [BelongField addTarget:self action:@selector(changedTextField_belong:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[[Handle_local_data alloc] init] Get_phone_info];
        GXCHttp *gxchttp = [[GXCHttp alloc] init];
        [self make_update_info: gxchttp op:@"add"];
        [gxchttp do_post:^(BOOL sucess, int state_code, NSString* err_reason) {
            if (sucess) {
                if (state_code == 200) {
                    UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"手机登记成功!" content:@"" isText:(BOOL) NO];
                    [self presentViewController:alertController animated:YES completion:^{
                        NSLog(@"sucess");
                        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                        [userDefault setObject:self.phone_number forKey:@"phone_number"];
                        [userDefault setObject:self.belong_name forKey:@"belong_name"];
                        [userDefault setObject:@"0" forKey:@"state"];
                        [userDefault synchronize];
                    }];
                } else {
                    UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"数据错误!" content:err_reason isText:(BOOL) NO];
                    [self presentViewController:alertController animated:YES completion:^{
                    }];
                }
            } else {
                UIAlertController *alertController = [[[GXCAlert_Control alloc] init] alert_title:@"手机登记失败，请稍后重试!" content:err_reason isText:(BOOL) NO];
                [self presentViewController:alertController animated:YES completion:^{
                    NSLog(@"sucess");
//                    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                    [userDefault setObject:self.phone_number forKey:@"phone_number"];
//                    [userDefault setObject:self.belong_name forKey:@"belong_name"];
//                    [userDefault setObject:@"0" forKey:@"state"];
//                    [userDefault synchronize];
                }];
            }
        }];
    }];

    otherAction.enabled = NO;
    self.secureTextAlertAction = otherAction;
    if ([type isEqualToString:@"change"]) {
        NSString *CancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:CancelButtonTitle style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:CancelAction];
    }
    
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) changedTextField_number:(UITextField*) __strong textField {
    self.bool_number = (textField.text.length > 0);
    self.phone_number = textField.text;
    self.secureTextAlertAction.enabled = self.bool_number && self.bool_belong;
}

- (void) changedTextField_belong:(UITextField*) __strong textField {
    self.bool_belong = (textField.text.length > 0);
    self.belong_name = textField.text;
    self.secureTextAlertAction.enabled = self.bool_number && self.bool_belong;
}

- (BOOL) isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void) make_update_info: (GXCHttp*) gxchttp op: (NSString*) op {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    gxchttp.ip_addr = [ConnectIP stringByAppendingString:phone_info_port];
    if (self.phone_number == nil) {
        self.phone_number = [userDefault objectForKey:@"phone_number"];
        self.belong_name = [userDefault objectForKey:@"belong_name"];
    }
    NSString *state = [[NSString alloc] init];
    if ([op isEqualToString:@"add"]) {
        state = @"0";
    } else {
        state = [userDefault objectForKey:@"state"];
    }
    
    gxchttp.dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.phone_number, @"phone_number", self.belong_name, @"belong_name", [userDefault objectForKey:@"phone"], @"phone", [userDefault objectForKey:@"platform"], @"platform", [userDefault objectForKey:@"sys_version"], @"sys_version", [userDefault objectForKey:@"name"], @"phone_name", state, @"state", @"1", @"isiOS", op, @"op", nil];
}

//获取当前时间戳
- (NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

//检查是否登记1
- (BOOL)check_login {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"phone_number"] == nil) {
        return NO;
    } else {
        return YES;
    }
}

//检查是否接触
- (BOOL)check_state {
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"state"] isEqualToString:@"0"]) {
        return NO;
    } else {
        return YES;
    }
}

@end
