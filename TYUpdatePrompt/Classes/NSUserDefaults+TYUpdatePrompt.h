//
//  NSUserDefaults+TYUpdatePrompt.h
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/24.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (TYUpdatePrompt)

- (void)tyup_storeLastVersionCheckPerformedDate:(NSDate *)date;

- (NSDate *)tyup_lastVersionCheckPerformedDate;

@end
