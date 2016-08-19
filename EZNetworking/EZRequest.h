//
//  EZRequest.h
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "EZNetworkConfig.h"

@class EZRequest;
typedef void(^EZRequestCompletionBlock)(__kindof EZRequest *request);

@interface EZRequest : NSObject

@property(nonatomic,strong,readonly) NSString *baseUrl;

@property(nonatomic,strong,readonly) NSString *strUrl;

@property (nonatomic, strong, readonly) NSString *responseString;

@property (nonatomic, strong, readonly) id responseModel;
/// 请求的URL
- (NSString *)requestUrl;

- (NSDictionary *)requestArgument;

- (EZRequestMethod)requestMethod;

//字典模型转换
-(id)jsonModel:(NSDictionary *)dict;

@property (nonatomic, copy) EZRequestCompletionBlock successCompletionBlock;

@property (nonatomic, copy) EZRequestCompletionBlock failureCompletionBlock;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(EZRequestCompletionBlock)success
                                    failure:(EZRequestCompletionBlock)failure;

@end
