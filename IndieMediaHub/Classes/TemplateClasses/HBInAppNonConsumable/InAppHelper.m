//
//  InAppHelper.m
//  
//
//  Created by Manikanta Chintapalli on 9/3/15.
//
//

#import "InAppHelper.h"

@implementation InAppHelper

+ (InAppHelper *)sharedInstance {
    static dispatch_once_t once;
    static InAppHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.trainsimple.annual",
                                      @"com.trainsimple.monthly",
                                      @"com.razeware.inapprage.drummerrage",
                                      @"com.razeware.inapprage.itunesconnectrage",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
