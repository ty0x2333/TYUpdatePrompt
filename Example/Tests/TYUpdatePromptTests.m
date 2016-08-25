//
//  TYUpdatePromptTests.m
//  TYUpdatePromptTests
//
//  Created by luckytianyiyan on 08/23/2016.
//  Copyright (c) 2016 luckytianyiyan. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi

#import <TYUpdatePrompt.h>
#import <OHHTTPStubs.h>
#import <OHHTTPStubsResponse.h>
#import <OHPathHelpers.h>

SPEC_BEGIN(TYUpdatePromptTests)

describe(@"check version tests", ^{

  context(@"app store version is newer", ^{
      
      __block TYUpdatePrompt *updatePrompt;
      
      beforeAll(^{
          updatePrompt = [[TYUpdatePrompt alloc] init];
          updatePrompt.debugEnabled = YES;
          
          [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
              return [request.URL.host isEqualToString:@"itunes.apple.com"] && [request.URL.path isEqualToString:@"/lookup"];
          } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
              NSString* fixture = OHPathForFile(@"com.tianyiyan.TYTumblr.json", self.class);
              return [OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                      statusCode:200 headers:@{@"Content-Type":@"application/json"}];
          }];
      });
    
      it(@"need update", ^{
          
          __block BOOL result = NO;
          [updatePrompt checkVersionWithCompletionHandler:^(BOOL isNeedUpdate, NSString * _Nonnull appName, TYUPAppStoreInfo * _Nullable appStoreInfo) {
              result = isNeedUpdate;
          }];
          
          [[expectFutureValue(theValue(result)) shouldEventually] beYes];
      });
      
  });

});

SPEC_END

