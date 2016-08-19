//
//  EZNetworkArgument.h
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import <Foundation/Foundation.h>

@interface EZNetworkArgument : NSObject

-(NSDictionary *)requestUrlArgument;

-(BOOL)responseCheckErrorCode:(NSDictionary *)dict;

@end
