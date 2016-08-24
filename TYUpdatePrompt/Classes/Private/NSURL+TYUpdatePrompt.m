//
//  NSURL+TYUpdatePrompt.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/24.
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
    
#warning test
    NSMutableArray<NSURLQueryItem *> *items = [@[[NSURLQueryItem queryItemWithName:@"bundleId" value:[NSBundle mainBundle].bundleIdentifier]] mutableCopy];
//    NSMutableArray<NSURLQueryItem *> *items = [@[[NSURLQueryItem queryItemWithName:@"bundleId" value:@"com.tianyiyan.TYTumblr"]] mutableCopy];

    
    if (countryCode) {
        NSURLQueryItem *countryQueryItem = [NSURLQueryItem queryItemWithName:@"country" value:countryCode];
        [items addObject:countryQueryItem];
    }
    
    components.queryItems = items;
    
    return components.URL;
}

@end
