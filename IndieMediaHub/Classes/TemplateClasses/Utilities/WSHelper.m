//
//  WSHelper.m
//  Custom properties
//
//  Created by PC-27 on 17/06/14.
//  Copyright (c) 2014 Custom properties. All rights reserved.
//

#import "WSHelper.h"
#import "Reachability.h"
@implementation WSHelper
+ (WSHelper *)sharedInstance {
	static WSHelper *wsHelper = nil;
	if (wsHelper == nil)
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            wsHelper = [[WSHelper alloc] init];
        });
	}
	
	return wsHelper;
}
- (void)getResponseFromURL:(NSString *)url requestMethod:(NSString *)methodType  parmeters:(NSMutableDictionary *)dicParams otherParameteres:(NSDictionary *)otherParameters completionHandler:(void (^)(id arrayResult, NSError *error))block {
    if([self reachable]) {
        
#ifdef DEBUG
        NSLog(@"==========********========\n=========getFianlWSURL========\n%@\n==========********========", [self getFianlWSURL:url]);
        NSLog(@"==========********========\n=========WS PARAMETERS========\n%@\n==========********========", dicParams);
#endif
   
    if ([methodType isEqualToString:REQUEST_TYPE_GET]) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[self getFianlWSURL:url] parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
                NSLog(@"==========********========\n=========WS Responce========\n%@\n==========********========", responseObject);
#endif
            block (responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
               NSLog(@"==========********========\n=========WS Failure========\n%@\n==========********========", [error description]);
#endif
            block (nil, error);
        }];
    } else if ([methodType isEqualToString:REQUEST_TYPE_POST]) {
        NSMutableArray *arrayMultiFormData = [NSMutableArray array];
        for (NSString *strKey in [dicParams allKeys]) {
            if([[dicParams objectForKey:strKey] isKindOfClass:[UIImage class]]) {
                NSMutableDictionary *dictMultiFormData = [NSMutableDictionary dictionary];
                [dictMultiFormData setObject:[dicParams objectForKey:strKey] forKey:@"image"];
                 [dictMultiFormData setObject:strKey forKey:@"keyName"];
                [arrayMultiFormData addObject:dictMultiFormData];
                [dicParams removeObjectForKey:strKey];
            }
        }
        if ([arrayMultiFormData count] == 0) {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:[self getFianlWSURL:url] parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
                    NSLog(@"==========********========\n=========WS Responce========\n%@\n==========********========", responseObject);
#endif
                block (responseObject, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
                    NSLog(@"==========********========\n=========WS Failure========\n%@\n==========********========", [error description]);
#endif
                block (nil, error);
            }];
        } else {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:[self getFianlWSURL:url] parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSDictionary *dict in arrayMultiFormData) {
                    [formData appendPartWithFileData:UIImagePNGRepresentation([dict valueForKey:@"image"]) name:[dict valueForKey:@"keyName"] fileName:[NSString stringWithFormat:@"%f.png", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/png"];
                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
#ifdef DEBUG
                   NSLog(@"==========********========\n=========WS Responce========\n%@\n==========********========", responseObject);
#endif
                block (responseObject, nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#ifdef DEBUG
                    NSLog(@"==========********========\n=========WS Failure========\n%@\n==========********========", [error description]);
#endif
                block (nil, error);
            }];
        }
    }
    }else  {
         block (nil, nil);
        [CustomUtility showAlertWithTitle:@"Connection Error" andMessage:@"Cannot load data.  There is no internet connection."];
       
    }
}
- (NSString *)getFianlWSURL:(NSString *)strUrl {
    if ([strUrl rangeOfString:@"http"].location == NSNotFound) {
        return strUrl = [NSString stringWithFormat:@"%@%@", PROJECT_BASE_URL, strUrl];
    } else {
        return strUrl;
    }
}
+ (BOOL)isInternetAvailable {
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
	if (reachability.isReachable) {
		return NO;
    } else {
		return YES;
	}
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
-(BOOL)reachable {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}
@end
