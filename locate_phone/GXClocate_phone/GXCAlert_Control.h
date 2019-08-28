//
//  GXCTap_Control.h
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/26.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXCAlert_Control : NSObject

- (UIAlertController*) alert_title: (NSString*) title content: (NSString*) content isText:(BOOL) istext;
//- (UIAlertController*) alert_double: (NSString*) title content: (NSString*) content isText:(BOOL) istext action:(SEL) action;

@end

NS_ASSUME_NONNULL_END
