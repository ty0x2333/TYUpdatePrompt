//
//  NSUserDefaults+TYUpdatePrompt.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/24.
//
//

#import "NSUserDefaults+TYUpdatePrompt.h"

NSString * const TYUpdatePromptDefaultStoredVersionCheckDate = @"com.tianyiyan.UpdatePromptDefaultStoredVersionCheckDate";


@implementation NSUserDefaults (TYUpdatePrompt)

- (void)tyup_storeLastVersionCheckPerformedDate:(NSDate *)date
{
    [self setObject:date forKey:TYUpdatePromptDefaultStoredVersionCheckDate];
    [self synchronize];
}

- (NSDate *)tyup_lastVersionCheckPerformedDate
{
    id result = [self objectForKey:TYUpdatePromptDefaultStoredVersionCheckDate];
    return [result isKindOfClass:[NSDate class]] ? result : nil;
}

@end
