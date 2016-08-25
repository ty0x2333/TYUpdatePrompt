//
//  TYUPAppStoreInfoTests.m
//  TYUPAppStoreInfoTests
//
//  Created by luckytianyiyan on 08/23/2016.
//  Copyright (c) 2016 luckytianyiyan. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

#import <TYUPAppStoreInfo.h>
#import <OHHTTPStubs.h>
#import <OHHTTPStubsResponse.h>
#import <OHPathHelpers.h>

SPEC_BEGIN(TYUPAppStoreInfoTests)

NSString * (^requiresVersionByOffset)(CGFloat systemVersion, CGFloat offset) = ^(CGFloat systemVersion, CGFloat offset) {
    CGFloat requireOSVersion = systemVersion + offset;
    return [NSString stringWithFormat:@"%.1f", requireOSVersion];
};

describe(@"TYUPAppStoreInfo tests", ^{

  context(@"check update compatible", ^{
      
      __block TYUPAppStoreInfo *appStoreInfo;
      __block CGFloat systemVersion;
      beforeAll(^{
          appStoreInfo = [[TYUPAppStoreInfo alloc] init];
          NSString *version = [UIDevice currentDevice].systemVersion;
          systemVersion = [version floatValue];
      });
    
      it(@"update compatible", ^{
          appStoreInfo.requiresOSVersion = requiresVersionByOffset(systemVersion, -.1f);
          [[theValue([appStoreInfo isUpdateCompatible]) should] beYes];
      });
      
      it(@"update compatible", ^{
          appStoreInfo.requiresOSVersion = requiresVersionByOffset(systemVersion, 0);
          [[theValue([appStoreInfo isUpdateCompatible]) should] beYes];
      });
      
      it(@"no update compatible", ^{
          appStoreInfo.requiresOSVersion = requiresVersionByOffset(systemVersion, .1f);
          [[theValue([appStoreInfo isUpdateCompatible]) should] beNo];
      });
  });

});

SPEC_END

