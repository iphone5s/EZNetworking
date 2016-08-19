//
//  NetworkArgument.m
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import "NetworkArgument.h"

@implementation NetworkArgument

-(NSDictionary *)requestUrlArgument
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"ipad" forKey:@"os"];
    [dict setValue:@"304971d23c0b4913af50f6cbe3c4d930" forKey:@"guid"];
    [dict setValue:@"304971d23c0b4913af50f6cbe3c4d930" forKey:@"deviceId"];
    [dict setValue:@"1.1" forKey:@"appvid"];
    [dict setValue:[NSNumber numberWithFloat:1024].description forKey:@"height"];
    [dict setValue:[NSNumber numberWithFloat:1366].description forKey:@"width"];
    [dict setValue:@"Unknown" forKey:@"network"];
    return dict;
}

@end
