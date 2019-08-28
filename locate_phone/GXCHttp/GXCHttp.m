//
//  GXCHttp.m
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/26.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import "GXCHttp.h"
#import <AFNetworking.h>

#define IP ([[UIScreen mainScreen] bounds].size.width)

@implementation GXCHttp
//@synthesize connect_state;
//@synthesize dict;
//@synthesize ip_addr;

-(void)do_get:(completeBlock)completeBlock {
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.封装参数
//    NSDictionary *dict = @{
//                           @"phone_number":@"1010302002283",
//                           @"sys_version":@"12.0",
//                           @"isiOS":@"1"
//                           };
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
//    NSString *ip_addr1 = self.ip_addr;
//    NSLog(@"---------%@----------", self.ip_addr);
//    NSString *url = @"https://www.baidu.com/";
    [manager GET:self.ip_addr parameters:self.dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        int statusCode = responseObject.statusCode;
//        NSDictionary* response_data = responseObject;
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        completeBlock(YES, 200, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(NO, -1, nil);
        NSLog(@"failure--%@",error);
    }];
}

-(void)do_post:(completeBlock)completeBlock{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:self.ip_addr parameters:self.dict progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        NSDictionary* response_data = responseObject;
        NSLog(@"%@", response_data);
        if ([[response_data objectForKey:@"code"] isEqualToString:@"error"]) {
            completeBlock(YES, -1, [response_data objectForKey:@"result"]);
        } else if ([[response_data objectForKey:@"code"] isEqualToString:@"same"]) {
            completeBlock(YES, -1, [response_data objectForKey:@"result"]);
        } else {
            completeBlock(YES, 200, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        completeBlock(NO, -1, nil);
        NSLog(@"failure--%@",error);
    }];
}


- (void)aFNetworkStatus:(netstateBlock)netstateBlock{
    
    //创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
//                netstateBlock(NO);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                netstateBlock(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
//                netstateBlock(NO);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
//                netstateBlock(YES);
                break;
                
            default:
                break;
        }
        
    }] ;
    
    [manager startMonitoring];
}


@end
