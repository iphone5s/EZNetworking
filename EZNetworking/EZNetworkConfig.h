//
//  EZNetworkConfig.h
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "EZNetworkArgument.h"

typedef NS_ENUM(NSInteger , EZRequestMethod) {
    EZRequestMethodGet = 0,
    EZRequestMethodPost,
};

@interface EZNetworkConfig : NSObject

+ (EZNetworkConfig *)sharedInstance;

@property (nonatomic,strong) NSString *baseUrl;

@property (nonatomic,assign) EZRequestMethod requestMethod;

@property (nonatomic,strong) EZNetworkArgument *arugment;

@end
