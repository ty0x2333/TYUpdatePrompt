//
//  TYUpdatePrompt.h
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/23.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYUpdatePrompt : NSObject

+ (instancetype)sharedInstance;

/**
 *  @brief OPTIONAL: If your application is not availabe in the U.S. Store, you must specify the two-letter country code for the region in which your applicaiton is available in.
 */
@property (nonatomic, copy, nullable) NSString *countryCode;

@property (nonatomic, assign, getter = isDebugEnabled) BOOL debugEnabled;

@property (nonatomic, copy, nullable) void (^checkVersionCallback)(BOOL isNeedUpdate);

- (void)checkVersion;

@end
