//
//  RNMessageAlertBridges.m
//  Cupid
//
//  Created by Trần Tý on 12/15/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNMessageAlertBridges, NSObject)
RCT_EXTERN_METHOD(
            selectAction: (NSString)id
            type: (NSString)type
)
RCT_EXTERN_METHOD(contactUs)
RCT_EXTERN_METHOD(reloadApp)
@end
