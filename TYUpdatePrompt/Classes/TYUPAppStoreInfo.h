//
//  TYUPAppStoreInfo.h
//  TYUpdatePrompt
//
//  Created by luckytianyiyan on 16/8/24.
//
//

#import <Foundation/Foundation.h>

@interface TYUPAppStoreInfo : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *releaseNotes;

- (BOOL)isAppStoreVersionNewer:(NSString *)targetVersion;

@end
