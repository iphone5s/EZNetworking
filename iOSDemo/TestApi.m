//
//  TestApi.m
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import "TestApi.h"

@implementation TestApi

- (NSString *)requestUrl {
    return @"/match/columnList";
}

- (id)requestArgument
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"100000" forKey:@"columnId"];
    return dict;
}

- (EZResponseMethod)responseMethod
{
    return EZResponseMethodCache1;
}

@end
