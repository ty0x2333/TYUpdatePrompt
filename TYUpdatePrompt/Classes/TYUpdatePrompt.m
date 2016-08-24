//
//  TYUpdatePrompt.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/23.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TYUpdatePrompt.h"
#import "NSUserDefaults+TYUpdatePrompt.h"
#import "NSURL+TYUpdatePrompt.h"
#import "TYUpAppStoreInfo.h"

@interface TYUpdatePrompt()

@property (nonatomic, strong) NSDate *lastVersionCheckPerformedDate;
@property (nonatomic, copy) NSString *currentVersion;

@property (nonatomic, strong) TYUPAppStoreInfo *appStoreInfo;

@end

@implementation TYUpdatePrompt

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TYUpdatePrompt alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _lastVersionCheckPerformedDate = [[NSUserDefaults standardUserDefaults] tyup_lastVersionCheckPerformedDate];
        _currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    return self;
}

- (void)checkVersion
{
    NSURL *storeURL = [NSURL tyup_itunesURLWithCountry:_countryCode];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:storeURL];
    
    [self log:[NSString stringWithFormat:@"storeURL: %@", storeURL]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                    [self log:[NSString stringWithFormat:@"error: %@", error.localizedDescription]];
                                                    return;
                                                }
                                                
                                                if (!data) {
                                                    return;
                                                }
                                                
                                                NSDictionary<NSString *, id> *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                
                                                [self log:[NSString stringWithFormat:@"Results: %@", appData]];
                                                
                                                [self parseResults:appData];
                                            }];
    [task resume];
}

- (void)parseResults:(NSDictionary<NSString *, id> *)appData
{
    NSParameterAssert(appData);
    
    NSArray *results = [appData objectForKey:@"results"];
    if (results.count < 1) {
        return;
    }
    
    _appStoreInfo = [[TYUPAppStoreInfo alloc] initWithDictionary:[results firstObject]];
    
    if (![self isUpdateCompatibleWithDeviceOS:appData]) {
        [self log:@"Device is not incompatible with installed verison of iOS"];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _lastVersionCheckPerformedDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] tyup_storeLastVersionCheckPerformedDate:_lastVersionCheckPerformedDate];
        
        if (_appStoreInfo.version.length < 0) {
            return;
        }
        
        if (![_appStoreInfo isAppStoreVersionNewer:_currentVersion]) {
            [self log:@"Currently installed version is newer."];
            return;
        }
        
        if (!_appStoreInfo.appID.length < 0) {
            [self log:@"error: appID is nil"];
        }
        
        [self log:@"need update"];
        if (_checkVersionCallback) {
            _checkVersionCallback(self.appName, _appStoreInfo);
        }
    });
}

- (void)launchAppStore
{
    if (!_appStoreInfo.appID) {
        [self log:@"error: appID is nil"];
        return;
    }
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", _appStoreInfo.appID];
    [self log:[NSString stringWithFormat:@"launch AppStore: %@", iTunesString]];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:iTunesURL];
    });
}

- (BOOL)isUpdateCompatibleWithDeviceOS:(NSDictionary<NSString *, id> *)appData
{
    NSArray<NSDictionary<NSString *, id> *> *results = appData[@"results"];
    if (results.count < 1) {
        return false;
    }
    
    NSString *requiresOSVersion = [results firstObject][@"minimumOsVersion"];
    if (!requiresOSVersion) {
        return false;
    }
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return [systemVersion compare:requiresOSVersion options:NSNumericSearch] == NSOrderedDescending || [systemVersion compare:requiresOSVersion options:NSNumericSearch] == NSOrderedSame;
}

#pragma mark - Setter / Getter

- (NSString *)appName
{
    if (!_appName) {
        _appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    }
    return _appName;
}

#pragma mark - Helper

- (void)log:(NSString *)message
{
    if (!self.isDebugEnabled) {
        return;
    }
    NSLog(@"<TYUpdatePrompt> %@", message);
}

@end
