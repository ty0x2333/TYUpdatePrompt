//
//  TYUPAppStoreInfo.m
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/24.
//
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
