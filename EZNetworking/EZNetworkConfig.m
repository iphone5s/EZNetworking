//
//  EZNetworkConfig.m
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import "EZNetworkConfig.h"

@implementation EZNetworkConfig

+ (EZNetworkConfig *)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestMethod = EZRequestMethodGet;
        self.responseMethod = EZResponseMethodDefault;
    }
    return self;
}

@end
