//
//  TYAppDelegate.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 08/23/2016.
//  Copyright (c) 2016 luckytianyiyan. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYViewController.h"

@implementation TYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[TYViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
