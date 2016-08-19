//
//  EZNetworkAgent.m
//  EZNetworking
//
//  Created by Ezreal on 16/8/18.
//
//

#import "EZNetworkAgent.h"
#import "EZNetworkConfig.h"
#import "AFNetworking.h"
#import "PINCache.h"
#import "CommonCrypto/CommonDigest.h"

@interface EZRequest ()

-(void) setResponseWithString:(NSString *)responseString model:(id)responseModel cache:(BOOL)isCache;

@end

@implementation EZNetworkAgent
{
    AFHTTPSessionManager *_manager;
    NSMutableDictionary *_requestsRecord;
    
    PINDiskCache *_cache;
}

+ (EZNetworkAgent *)sharedInstance {
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
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
        _requestsRecord = [NSMutableDictionary dictionary];
        
        _cache = [PINDiskCache sharedCache];
    }
    return self;
}

- (NSString *)md5String:(NSString *)strCode
{
    const char *string = strCode.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    
    NSMutableString *mutableString = @"".mutableCopy;
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [mutableString appendFormat:@"%02x", bytes[i]];
    }
    
    return mutableString;
}

-(void)addRequest:(EZRequest *)request{
    
    EZResponseMethod responseMethod = [request responseMethod];
    
    switch (responseMethod)
    {
        case EZResponseMethodDefault:
        {
            NSURLSessionDataTask *task = [self sendNetworkRequest:request];
            
            [self addSessionDataTask:request task:task];
        }
            break;
        case EZResponseMethodCache1:
        {
            NSString *strKey = [self md5String:request.strUrl];
            id responseObject = [_cache objectForKey:strKey];
            
            if (responseObject)
            {
                [self handleCache:request responseObject:responseObject];
            }
            else
            {
                NSURLSessionDataTask *task = [self sendNetworkRequest:request];
                [self addSessionDataTask:request task:task];
            }

            
        }
            break;
        case EZResponseMethodCache2:
        {
            
        }
            break;
        default:
            break;
    }
    

}

-(NSDictionary *)getParameters:(EZRequest *)request
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([[EZNetworkConfig sharedInstance].arugment requestUrlArgument])
    {
        [parameters addEntriesFromDictionary:[[EZNetworkConfig sharedInstance].arugment requestUrlArgument]];
    }
    
    if ([request requestArgument])
    {
        [parameters addEntriesFromDictionary:[request requestArgument]];
    }
    
    return parameters;
}

- (NSURLSessionDataTask *)sendNetworkRequest:(EZRequest *)request
{
    EZRequestMethod requestMethod = [request requestMethod];
    NSString *strUrl = request.baseUrl;
    
    NSDictionary *parameters = [self getParameters:request];
    
    switch (requestMethod) {
        case EZRequestMethodGet:
        {
            return [_manager GET:strUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResult:task responseObject:responseObject];
                [self removeSessionDataTask:task];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResult:task responseObject:nil];
                [self removeSessionDataTask:task];
            }];
        }
            break;
        case EZRequestMethodPost:
        {
            return [_manager POST:strUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResult:task responseObject:responseObject];
                [self removeSessionDataTask:task];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResult:task responseObject:nil];
                [self removeSessionDataTask:task];
            }];
        }
            break;
        default:
            break;
    }
    
}

-(void)handleCache:(EZRequest *)request responseObject:(id)responseObject
{
    BOOL succeed = [self checkResult:request responseObject:responseObject];
    
    if (succeed)
    {
        id model = [request jsonModel:responseObject];
        [request setResponseWithString:responseObject model:model cache:YES];
    }
    
    [self callBack:request success:succeed];
}

-(void)handleResult:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    EZRequest *request = _requestsRecord[task.taskDescription];
    
    if (request)
    {
        BOOL succeed = [self checkResult:request responseObject:responseObject];
        
        if (succeed)
        {
            id model = [request jsonModel:responseObject];
            [request setResponseWithString:responseObject model:model cache:NO];
            
            NSString *strKey = [self md5String:request.strUrl];
            [_cache setObject:responseObject forKey:strKey];
        }
        else
        {
            
        }
        
        [self callBack:request success:succeed];
        
    }
}

-(void)callBack:(EZRequest *)request success:(BOOL)success
{
    if (success)
    {
        if (request.successCompletionBlock)
        {
            request.successCompletionBlock(request);
        }
    }
    else
    {
        if (request.failureCompletionBlock)
        {
            request.failureCompletionBlock(request);
        }
    }
}

- (BOOL)checkResult:(EZRequest *)request responseObject:(id)responseObject
{
    if (responseObject && [EZNetworkConfig sharedInstance].arugment) {
        return [[EZNetworkConfig sharedInstance].arugment responseCheckErrorCode:responseObject];
    }else{
        return NO;
    }
}

- (void)addSessionDataTask:(EZRequest *)request task:(NSURLSessionDataTask *)task
{
    if (task != nil)
    {
        @synchronized (self)
        {
            [_requestsRecord setObject:request forKey:task.taskDescription];
        }
    }
}

- (void)removeSessionDataTask:(NSURLSessionDataTask *)task {
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:task.taskDescription];
    }
}

@end
