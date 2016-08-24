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
    }
    return self;
}

@end
