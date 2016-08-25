//
//  TYUpdatePrompt.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/23.
//
//  Copyright (c) 2016 luckytianyiyan <luckytianyiyan@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

- (void)checkVersionWithCompletionHandler:(void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo))completion
{
    NSURL *storeURL = [NSURL tyup_itunesURLWithCountry:_countryCode];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:storeURL];
    
    [self log:@"Request: %@", storeURL];
    
    void (^completionHandler)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        BOOL isParseSuccess = NO;
        NSArray *results;
        do {
            if (error) {
                [self log:@"error: %@", error.localizedDescription];
                break;
            }
            if (!data) {
                break;
            }
            NSError *jsonError;
            NSDictionary<NSString *, id> *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            if (jsonError) {
                [self log:@"error: %@", error.localizedDescription];
                break;
            }
            [self log:@"Response: %@", appData];
            
            results = [appData objectForKey:@"results"];
            if (results.count < 1) {
                break;
            }
            
            isParseSuccess = YES;
        } while (0);
        
        if (!isParseSuccess) {
            completion(NO, self.appName, nil);
            return;
        }
        
        _appStoreInfo = [[TYUPAppStoreInfo alloc] initWithDictionary:[results firstObject]];
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isNeedUpdate = NO;
            
            _lastVersionCheckPerformedDate = [NSDate date];
            [[NSUserDefaults standardUserDefaults] tyup_storeLastVersionCheckPerformedDate:_lastVersionCheckPerformedDate];

            do {
                if (![_appStoreInfo isUpdateCompatible]) {
                    [self log:@"Device is not incompatible with installed verison of iOS"];
                    break;
                }
                if (![_appStoreInfo isAppStoreVersionNewer:_currentVersion]) {
                    [self log:@"Currently installed version is newer."];
                    break;
                }
                if (!_appStoreInfo.appID.length < 1) {
                    [self log:@"error: appID is nil"];
                }
                isNeedUpdate = YES;
            } while (0);
            
            if (completion) {
                completion(isNeedUpdate, self.appName, _appStoreInfo);
            }
            
        });
    };
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

- (void)checkVersionDailyWithCompletionHandler:(void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo))completion
{
    [self checkVersionWithCycle:1 completionHandler:completion];
}

- (void)checkVersionWeeklyWithCompletionHandler:(void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo))completion
{
    [self checkVersionWithCycle:7 completionHandler:completion];
}

- (void)checkVersionWithCycle:(NSUInteger)day completionHandler:(void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo *appStoreInfo))completion
{
    if (!_lastVersionCheckPerformedDate) {
        
        _lastVersionCheckPerformedDate = [NSDate date];
        [self checkVersionWithCompletionHandler:completion];
        
        return;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:_lastVersionCheckPerformedDate toDate:[NSDate date] options:0];
    
    NSInteger *interval = [components day];
    
    if (interval > day) {
        [self checkVersionWithCompletionHandler:nil];
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
