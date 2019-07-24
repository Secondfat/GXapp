//
//  AppDelegate.h
//  locate_phone
//
//  Created by guoxiangchen on 2019/7/24.
//  Copyright © 2019 guoxiangchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

