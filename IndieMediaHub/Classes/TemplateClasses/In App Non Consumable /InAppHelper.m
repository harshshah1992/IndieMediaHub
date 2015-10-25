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
    // Give your product identifiers here.
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"First Product identifier",
                                      @"Second Product identifier",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
