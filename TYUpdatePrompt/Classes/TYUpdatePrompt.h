//
//  TYUpdatePrompt.h
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

#import <Foundation/Foundation.h>
#import "TYUPAppStoreInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYUpdatePrompt : NSObject

+ (instancetype)sharedInstance;

/**
 *  @brief OPTIONAL: If your application is not availabe in the U.S. Store, you must specify the two-letter country code for the region in which your applicaiton is available in.
 */
@property (nonatomic, copy, nullable) NSString *countryCode;

@property (nonatomic, assign, getter = isDebugEnabled) BOOL debugEnabled;

@property (nonatomic, copy) NSString *appName;

- (void)launchAppStore;

#pragma mark - Check Version

- (void)checkVersionWithCompletionHandler:(nullable void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo * __nullable appStoreInfo))completion;

- (void)checkVersionDailyWithCompletionHandler:(nullable void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo * __nullable appStoreInfo))completion;

- (void)checkVersionWeeklyWithCompletionHandler:(nullable void (^)(BOOL isNeedUpdate, NSString *appName, TYUPAppStoreInfo * __nullable appStoreInfo))completion;

@end

NS_ASSUME_NONNULL_END