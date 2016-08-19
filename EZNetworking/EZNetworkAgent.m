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

@interface EZRequest ()

-(void) setResponseWithString:(NSString *)responseString model:(id)responseModel;

@end

@implementation EZNetworkAgent
{
    AFHTTPSessionManager *_manager;
    NSMutableDictionary *_requestsRecord;
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
    }
    return self;
}

-(void)addRequest:(EZRequest *)request{
    
    EZRequestMethod requestMethod = [request requestMethod];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([[EZNetworkConfig sharedInstance].arugment requestUrlArgument])
    {
        [parameters addEntriesFromDictionary:[[EZNetworkConfig sharedInstance].arugment requestUrlArgument]];
    }
    
    if ([request requestArgument])
    {
        [parameters addEntriesFromDictionary:[request requestArgument]];
    }
    
    NSURLSessionDataTask *task = [self sendNetworkRequest:requestMethod url:request.baseUrl parameters:parameters];
    
    [self addSessionDataTask:request task:task];
}

- (NSURLSessionDataTask *)sendNetworkRequest:(EZRequestMethod)requestMethod url:(NSString *)url parameters:(id)parameters
{
    
    switch (requestMethod) {
        case EZRequestMethodGet:
        {
            return [_manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
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
            return [_manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
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

-(void)handleResult:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    EZRequest *request = _requestsRecord[task.taskDescription];
    
    if (request)
    {
        BOOL succeed = [self checkResult:request responseObject:responseObject];
        
        if (succeed)
        {
            id model = [request jsonModel:responseObject];
            [request setResponseWithString:responseObject model:model];
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
