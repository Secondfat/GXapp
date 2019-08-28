//
//  GXCHttp.h
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/26.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^completeBlock)(BOOL success, int err_code, NSString* err_reason);
typedef void(^netstateBlock)(BOOL success);

@interface GXCHttp : NSObject

- (void) do_get:(completeBlock)completeBlock;
- (void) do_post:(completeBlock)completeBlock;
//-(void)getJsonDataFromUrl:(NSString *)url success:(void(^)(id json))success faile:(void(^)())faile;
- (void)aFNetworkStatus;
@property (nonatomic,assign) BOOL connect_state;
@property (nonatomic,strong) NSString *ip_addr;
@property (nonatomic,strong) NSMutableDictionary *dict;
//@property (nonatomic,strong) NSDictionary *back_dict;
//@property (nonatomic,strong) completeBlock completeblock;

@end

NS_ASSUME_NONNULL_END
