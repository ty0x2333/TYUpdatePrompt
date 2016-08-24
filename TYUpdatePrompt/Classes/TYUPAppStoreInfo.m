//
//  TYUPAppStoreInfo.m
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

#import "TYUPAppStoreInfo.h"

@implementation TYUPAppStoreInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _version = [dic objectForKey:@"version"];
        
        _appID = [[dic objectForKey:@"trackId"] stringValue];
        
        _releaseNotes = [dic objectForKey:@"releaseNotes"];
        
        _requiresOSVersion = [dic objectForKey:@"minimumOsVersion"];
    }
    return self;
}

- (BOOL)isAppStoreVersionNewer:(NSString *)targetVersion
{
    if (targetVersion.length < 1 || _version.length < 1) {
        return NO;
    }
    return [targetVersion compare:_version options:NSNumericSearch] == NSOrderedAscending;
}

- (BOOL)isUpdateCompatible
{
    if (_requiresOSVersion.length < 1) {
        return NO;
    }
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return [systemVersion compare:_requiresOSVersion options:NSNumericSearch] == NSOrderedDescending || [systemVersion compare:_requiresOSVersion options:NSNumericSearch] == NSOrderedSame;
}

@end
