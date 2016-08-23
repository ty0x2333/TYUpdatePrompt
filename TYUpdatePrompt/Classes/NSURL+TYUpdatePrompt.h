//
//  NSURL+TYUpdatePrompt.h
//  Pods
//
//  Created by luckytianyiyan on 16/8/24.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (TYUpdatePrompt)

+ (NSURL *)tyup_itunesURL;

+ (NSURL *)tyup_itunesURLWithCountry:(nullable NSString *)countryCode;

@end

NS_ASSUME_NONNULL_END
