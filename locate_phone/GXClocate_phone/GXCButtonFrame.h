//
//  GXCButtonFrame.h
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/25.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GXCButtonFrame : UIViewController

- (UIButton*) SetButtonFrame:(NSString*) name image: (NSString*) image_name index: (int) i;
- (UILabel*) SetLabelFrame: (NSString*) name size: (int) size index: (int) i;
@property (strong, nonatomic) UIButton *tap_button;
@property (strong, nonatomic) UILabel *button_label;

@end

NS_ASSUME_NONNULL_END
