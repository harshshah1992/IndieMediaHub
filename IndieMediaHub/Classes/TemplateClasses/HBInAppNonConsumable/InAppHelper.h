//
//  InAppHelper.h
//
//
// Created by Manikanta Chintapalli on 9/3/15.
//


#import "IAPHelper.h"

@interface InAppHelper : IAPHelper
+ (InAppHelper *)sharedInstance;
@property (nonatomic, strong) NSSet *productIdentifiers;

@end
