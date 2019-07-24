//
//  GXCButtonFrame.m
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/25.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import "GXCButtonFrame.h"
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


@implementation GXCButtonFrame
- (UIButton *)SetButtonFrame:(NSString *)name image:(NSString *)image_name index:(int)i {
    float width_start = SCREEN_WIDTH/4;
    float heigth_start = (SCREEN_HEIGHT/10) * i + (SCREEN_HEIGHT/6) * (i - 1);
    float width_image = SCREEN_WIDTH/2 + 10;
    float heigth_image = SCREEN_HEIGHT/5;
    
    self.tap_button = [[UIButton alloc] initWithFrame:CGRectMake(width_start , heigth_start, width_image , heigth_image)];
    UIImage *image_status = [UIImage imageNamed:image_name];
    [self.tap_button setTitle:name forState:UIControlStateNormal];
    [self.tap_button setBackgroundImage: image_status forState:UIControlStateNormal];
    [self.tap_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return self.tap_button;
}

- (UILabel*) SetLabelFrame:(NSString *)name size:(int)size index:(int)i {
    float width_start = SCREEN_WIDTH/2 - 5;
    float heigth_start = (SCREEN_HEIGHT/10) * i + (SCREEN_HEIGHT/6) * i + 8;
    float width_script = SCREEN_WIDTH/8;
    float heigth_script = SCREEN_HEIGHT/10 - 8;
    
    self.button_label = [[UILabel alloc] initWithFrame:CGRectMake(width_start, heigth_start, width_script, heigth_script)];
    self.button_label.text = name;
    self.button_label.font = [UIFont fontWithName:@"Arial" size:size];
    return self.button_label;
}



@end
