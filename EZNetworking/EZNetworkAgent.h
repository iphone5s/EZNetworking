//
//  EZNetworkAgent.h
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "EZRequest.h"

@interface EZNetworkAgent : NSObject

+ (EZNetworkAgent *)sharedInstance;

- (void)addRequest:(EZRequest *)request;

@end
