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

- (void)parseResults:(NSDictionary<NSString *, id> *)appData
{
    NSParameterAssert(appData);
    
    NSArray *results = [appData objectForKey:@"results"];
    if (results.count < 1) {
        return;
    }
    
    _appStoreInfo = [[TYUPAppStoreInfo alloc] initWithDictionary:[results firstObject]];
    
    if (![_appStoreInfo isUpdateCompatible]) {
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
    [self log:@"launch AppStore: %@", iTunesString];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:iTunesURL];
    });
}

#pragma mark - Check Version

- (void)checkVersion
{
    NSURL *storeURL = [NSURL tyup_itunesURLWithCountry:_countryCode];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:storeURL];
    
    [self log:@"storeURL: %@", storeURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error) {
                                                    [self log:@"error: %@", error.localizedDescription];
                                                    return;
                                                }
                                                
                                                if (!data) {
                                                    return;
                                                }
                                                
                                                NSDictionary<NSString *, id> *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                
                                                [self log:@"Results: %@", appData];
                                                
                                                [self parseResults:appData];
                                            }];
    [task resume];
}

- (void)checkVersionDaily
{
    [self checkVersionWithCycle:1];
}

- (void)checkVersionWeekly
{
    [self checkVersionWithCycle:7];
}

- (void)checkVersionWithCycle:(NSUInteger)day
{
    if (!_lastVersionCheckPerformedDate) {
        
        _lastVersionCheckPerformedDate = [NSDate date];
        [self checkVersion];
        
        return;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:_lastVersionCheckPerformedDate toDate:[NSDate date] options:0];
    
    NSInteger *interval = [components day];
    
    if (interval > day) {
        [self checkVersion];
    }
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

- (void)log:(NSString *)format, ...
{
    if (!self.isDebugEnabled) {
        return;
    }
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    NSLog(@"<TYUpdatePrompt> %@", message);
    va_end(args);
}

@end
