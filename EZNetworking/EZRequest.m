//
//  EZRequest.m
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import "EZRequest.h"
#import "AFURLRequestSerialization.h"
#import "EZNetworkConfig.h"
#import "EZNetworkAgent.h"

@implementation EZRequest
@synthesize responseString = _responseString;

- (NSString *)requestUrl {
    return @"";
}

- (NSDictionary *)requestArgument {
    return nil;
}

- (EZRequestMethod)requestMethod {
    return [EZNetworkConfig sharedInstance].requestMethod;
}

- (EZResponseMethod)responseMethod {
    return [EZNetworkConfig sharedInstance].responseMethod;
}

-(id)jsonModel:(NSDictionary *)dict
{
    return nil;
}

/// block回调
- (void)startWithCompletionBlockWithSuccess:(EZRequestCompletionBlock)success
                                    failure:(EZRequestCompletionBlock)failure
{
    [self setCompletionBlockWithSuccess:success failure:failure];

    [[EZNetworkAgent sharedInstance] addRequest:self];
}

- (void)setCompletionBlockWithSuccess:(EZRequestCompletionBlock)success
                              failure:(EZRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (NSString *)baseUrl{
    
    NSString *detailUrl = [self requestUrl];
    if ([detailUrl hasPrefix:@"http"])
    {
        return detailUrl;
    }
    
    EZNetworkConfig *config = [EZNetworkConfig sharedInstance];
    
    return [NSString stringWithFormat:@"%@/%@",config.baseUrl,detailUrl];
}

-(NSString *)strUrl
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([[EZNetworkConfig sharedInstance].arugment requestUrlArgument])
    {
        [parameters addEntriesFromDictionary:[[EZNetworkConfig sharedInstance].arugment requestUrlArgument]];
    }
    
    if ([self requestArgument])
    {
        [parameters addEntriesFromDictionary:[self requestArgument]];
    }
    
    return [NSString stringWithFormat:@"%@?%@",[self baseUrl],AFQueryStringFromParameters(parameters)];
}

- (NSString *)responseString {
    return _responseString;
}

-(void) setResponseWithString:(NSString *)responseString model:(id)responseModel cache:(BOOL)isCache
{
    _responseString = responseString;
    _responseModel = responseModel;
}

-(void)dealloc
{
    NSLog(@"request 释放");
}

@end
