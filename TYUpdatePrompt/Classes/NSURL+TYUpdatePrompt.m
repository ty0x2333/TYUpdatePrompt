//
//  NSURL+TYUpdatePrompt.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/24.
//
//

#import "NSURL+TYUpdatePrompt.h"

@implementation NSURL (TYUpdatePrompt)

+ (NSURL *)tyup_itunesURL
{
    return [self tyup_itunesURLWithCountry:nil];
}

+ (NSURL *)tyup_itunesURLWithCountry:(NSString *)countryCode
{
    NSURLComponents *components = [NSURLComponents new];
    components.scheme = @"https";
    components.host = @"itunes.apple.com";
    components.path = @"/lookup";
    
    NSMutableArray<NSURLQueryItem *> *items = [@[[NSURLQueryItem queryItemWithName:@"bundleId" value:[NSBundle mainBundle].bundleIdentifier]] mutableCopy];
    
    if (countryCode) {
        NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country" value:countryCode];
        [items addObject:countryQueryItem];
    }
    
    components.queryItems = items;
    
    return components.URL;
}

@end
