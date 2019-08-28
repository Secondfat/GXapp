//
//  GXCTap_Control.m
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/26.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import "GXCAlert_Control.h"
#import <UIKit/UIKit.h>

@implementation GXCAlert_Control

- (UIAlertController*)alert_title: (NSString*) title content: (NSString*) content isText:(BOOL) istext{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionDefault = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //为了防止循环引用，在这里需要进行弱引用设置，下面如果有用到alertController的也需要做相同的处理
//        NSString *text = action.textFields.lastObject.text;
//        action.enabled = NumberField.text.length && BelongField.text.length;
//        NSLog(@"%@",text);
    }];
    
    if (istext) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull NumberField) {
            NumberField.placeholder = @"请输入此手机的编号";
            [NumberField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull BelongField) {
            BelongField.placeholder = @"请输入此手机的负责人";
            [BelongField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        }];
    }
    [alertController addAction:actionDefault];
    return alertController;
}

//- (UIAlertController*) alert_double :(NSString *)title content:(NSString *)content isText:(BOOL)istext action:(nonnull SEL)action{
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
//    if (istext) {
//        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = @"请输入借用者的名字";
//        }];
//    }
//    
//    UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *comfirmAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        SEL aSelector = @selector(action);
//        [performSelector:aSelector];
//        //点击确定要执行的代码
//    }];
//    
//    [alertVC addAction:cancelAc];
//    [alertVC addAction:comfirmAc];
//    return alertVC;
//}

//- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
//    UITextField *textField = notification.object;
//    // Enforce a minimum length of >= 5 characters for secure text alerts.
//    self.secureTextAlertAction.enabled = textField.text.length >= 5;
//}



//- (void)shakeField:(UIAlertController *)textField {
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.duration = 0.07;
//    animation.repeatCount = 4;
//    animation.autoreverses = YES;
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(int(textField.center) - 10, textField.centerYAnchor)];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(int(textField.center) + 10, textField.centerY)];
//    [textField.layer addAnimation:animation forKey:@"position"];
//}

//- (void)textChange
//{
//    NSLog(@"accountTextF==%@",self.accountTextF.text);
//    //当账号与密码同时有值,登录按钮才能够点击
//    self.loginBtn.enabled = self.accountTextF.text.length && self.pwdTextF.text.length;
//
//}

//-(void)changedTextField:(id)textField
//{
//    NSLog(@"值是---%@",textField.text);
//}

@end
