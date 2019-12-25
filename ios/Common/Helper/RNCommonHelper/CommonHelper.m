//
//  CommonHelper.m
//  Cupid
//
//  Created by Trần Tý on 12/25/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNCommonHelper, NSObject)

RCT_EXTERN_METHOD(
                  showFlashMessage:(NSString)title
                  message: (NSString)message
                  rawTheme: (NSString)theme
)


@end
