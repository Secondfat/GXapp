//
//  Handle_local_data.m
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/29.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import "Handle_local_data.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>


@implementation Handle_local_data

- (NSString *)Get_phone_info {
    [self device_info];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"name"];
    NSString *model = [userDefault objectForKey:@"model"];
    NSString *sysversion = [userDefault objectForKey:@"sys_version"];
    NSString *phone_number = [userDefault objectForKey:@"phone_number"];
    NSString *belong_name = [userDefault objectForKey:@"belong_name"];
    NSString *state = [userDefault objectForKey:@"state"];
    NSString *borrow_name = [userDefault objectForKey:@"borrow_name"];
    NSString *borrow_time = [userDefault objectForKey:@"borrow_time"];
    NSString *phone_info = [[NSString alloc] init];
    if ([state isEqualToString:@"0"]) {
        phone_info = [NSString stringWithFormat:@"编号：%@\n归属人：%@\n型号：%@\n系统版本：%@\n有无借出：无", phone_number, belong_name, model, sysversion];
    } else {
        int now_time = [[self getNowTimeTimestamp] intValue];
        int dur_day = (now_time - [borrow_time intValue]) / 86400 + 1;
        [self Store_dic_key:@"dur_day" dict_value:[NSString stringWithFormat:@"%d", dur_day]];
        phone_info = [NSString stringWithFormat:@"编号：%@\n归属人：%@\n型号：%@\n系统版本：%@\n有无借出：有\n借给：%@\n已借走%d天", phone_number, belong_name, model, sysversion, borrow_name, dur_day];
    }
    return phone_info;
}

- (void) Store_dic_key: (NSString*) key dict_value: (NSString*) value {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:value forKey:key];
    [userDefault synchronize];
}

- (void) device_info {
    NSString* platform = [self platform];
    NSString* model = [self currentModel:platform];
    UIDevice* myDecive = [UIDevice currentDevice];
    NSString* name = myDecive.name;
    NSString* sysversion = myDecive.systemVersion;
    
    [self Store_dic_key:@"name" dict_value:name];
    [self Store_dic_key:@"platform" dict_value:platform];
    [self Store_dic_key:@"phone" dict_value:model];
    [self Store_dic_key:@"sys_version" dict_value:sysversion];
    [self Store_dic_key:@"model" dict_value:model];
}

- (NSString*) get_current_version {
    UIDevice* myDecive = [UIDevice currentDevice];
    NSString* sysversion = myDecive.systemVersion;
    return sysversion;
}

- (NSString *)platform {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}

- (NSString *)currentModel:(NSString *)phoneModel {
    if ([phoneModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([phoneModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([phoneModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([phoneModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([phoneModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([phoneModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([phoneModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([phoneModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([phoneModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([phoneModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([phoneModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([phoneModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([phoneModel isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([phoneModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([phoneModel isEqualToString:@"iPhone10,4"])   return @"iPhone 8 GSM";
    if ([phoneModel isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus GSM";
    if ([phoneModel isEqualToString:@"iPhone10,6"])   return @"iPhone X GSM";
    
    if ([phoneModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([phoneModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max (China)";
    if ([phoneModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([phoneModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";

    return [NSString stringWithFormat:@"%@",phoneModel];
}

//获取当前时间戳
- (NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}

@end
