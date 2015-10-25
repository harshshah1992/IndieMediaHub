//
//  WSHelper.h
//  Custom properties
//
//  Created by PC-27 on 17/06/14.
//  Copyright (c) 2014 Custom properties. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSHelper : NSObject
+ (WSHelper*)sharedInstance;
- (void)getResponseFromURL:(NSString *)url requestMethod:(NSString *)methodType  parmeters:(NSMutableDictionary *)dicParams otherParameteres:(NSDictionary *)otherParameters completionHandler:(void (^)(id arrayResult, NSError *error))block;
+ (BOOL)isInternetAvailable;
- (BOOL)reachable;
@end
