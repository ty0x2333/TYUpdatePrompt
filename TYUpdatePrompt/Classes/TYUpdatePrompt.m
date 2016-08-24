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

@interface TYUpdatePrompt()

@property (nonatomic, strong) NSDate *lastVersionCheckPerformedDate;
@property (nonatomic, copy) NSString *currentVersion;
@property (nonatomic, copy) NSString *appID;

@property (nonatomic, copy, readonly) NSString *appStoreVersion;

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
                                                    if (_checkVersionCallback) {
                                                        _checkVersionCallback(NO);
                                                    }
                                                    return;
                                                }
                                                
                                                if (!data) {
                                                    if (_checkVersionCallback) {
                                                        _checkVersionCallback(NO);
                                                    }
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
    
    if (![self isUpdateCompatibleWithDeviceOS:appData]) {
        [self log:@"Device is not incompatible with installed verison of iOS"];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _lastVersionCheckPerformedDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] tyup_storeLastVersionCheckPerformedDate:_lastVersionCheckPerformedDate];
        
        NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
        
        if (versionsInAppStore.count < 1) {
            if (_checkVersionCallback) {
                _checkVersionCallback(NO);
            }
            return;
        }
        
        _appStoreVersion = [versionsInAppStore firstObject];
        if (![self isAppStoreVersionNewer]) {
            [self log:@"Currently installed version is newer."];
            if (_checkVersionCallback) {
                _checkVersionCallback(NO);
            }
            return;
        }
        
        _appID = appData[@"results"][0][@"trackId"];
        
        if (!_appID) {
            [self log:@"error: appID is nil"];
        }
        
        [self log:@"need update"];
        if (_checkVersionCallback) {
            _checkVersionCallback(YES);
        }
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

#pragma mark - Comparator

- (BOOL)isAppStoreVersionNewer
{
    if (!self.currentVersion || !self.appStoreVersion) {
        return NO;
    }
    return [self.currentVersion compare:self.appStoreVersion options:NSNumericSearch] == NSOrderedAscending;
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
