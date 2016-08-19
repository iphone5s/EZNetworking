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

typedef NS_ENUM(NSInteger , EZResponseMethod) {
    EZResponseMethodDefault = 0,//不使用缓存
    EZResponseMethodCache1,//返回缓存数据，或者请求数据。
    EZResponseMethodCache2,//先返回缓存，再请求数据。
};

@interface EZNetworkConfig : NSObject

+ (EZNetworkConfig *)sharedInstance;

@property (nonatomic,strong) NSString *baseUrl;

@property (nonatomic,assign) EZRequestMethod requestMethod;

@property (nonatomic,assign) EZResponseMethod responseMethod;

@property (nonatomic,strong) EZNetworkArgument *arugment;

@end
