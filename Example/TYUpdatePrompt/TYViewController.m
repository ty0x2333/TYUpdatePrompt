//
//  TYViewController.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 08/23/2016.
//  Copyright (c) 2016 luckytianyiyan. All rights reserved.
//

#import "TYViewController.h"
#import <TYUpdatePrompt.h>
#import <Masonry.h>

@interface TYViewController()<UIAlertViewDelegate>

@end

@implementation TYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TYUpdatePrompt sharedInstance].debugEnabled = YES;
    
    UIButton *checkVersionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [checkVersionButton setTitle:@"Check Version" forState:UIControlStateNormal];
    [checkVersionButton addTarget:self action:@selector(onCheckVersionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkVersionButton];
    
    [checkVersionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    UILabel *debugLabel = [[UILabel alloc] init];
    debugLabel.font = [UIFont systemFontOfSize:14.f];
    debugLabel.text = @"Debug Switch";
    [self.view addSubview:debugLabel];
    
    UISwitch *debugSwitch = [[UISwitch alloc] init];
    debugSwitch.on = [TYUpdatePrompt sharedInstance].isDebugEnabled;
    [debugSwitch addTarget:self action:@selector(onDebugSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:debugSwitch];
    
    [debugSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(checkVersionButton.mas_top).offset(-20.f);
        make.left.equalTo(checkVersionButton.mas_centerX).offset(10.f);
    }];
    
    [debugLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(checkVersionButton.mas_centerX).offset(-10.f);
        make.centerY.equalTo(debugSwitch);
    }];
    
}

- (void)onCheckVersionButtonClicked:(UIButton *)sender
{
    NSLog(@"Check Version");
    TYUpdatePrompt *updatePrompt = [TYUpdatePrompt sharedInstance];
    [updatePrompt checkVersionWithCompletionHandler:^(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo) {
        if (isNeedUpdate) {
            NSString *title = @"Update Available";
            NSString *message = [NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.\n\nRelease Notes\n\n%@",
                                 appName,
                                 appStoreInfo.version,
                                 appStoreInfo.releaseNotes];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Update", @"Next time", nil];
            [alertView show];
        }
    }];
}

- (void)onDebugSwitchValueChanged:(UISwitch *)sender
{
    NSLog(@"Debug %@", sender.isOn ? @"On" : @"Off");
    [TYUpdatePrompt sharedInstance].debugEnabled = sender.isOn;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[TYUpdatePrompt sharedInstance] launchAppStore];
            break;
            
        default:
            break;
    }
}

@end
