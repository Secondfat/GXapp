//
//  Handle_local_data.h
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/29.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Handle_local_data : NSObject

- (NSString *) Get_phone_info;
- (NSString *) get_current_version;
- (void) Store_dic_key: (NSString*) key dict_value: (NSString*) value;

@end

NS_ASSUME_NONNULL_END
