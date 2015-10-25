//
//  NSNull+CustomCategory.h
//  Exception Handling
//
//  Created by Apple IMac on 07/06/13.
//  Copyright (c) 2013 companyName All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (NSNull_CustomCategory)

/**
 Returns 0 if this method is called on NSNull object.
 */

- (BOOL)length;

/**
 Returns 0 length string if this method is called on NSNull object.
 */

- (NSString *)uppercaseString;

/**
 Returns 0 length string if this method is called on NSNull object.
 */

- (NSString *)lowercaseString;

/**
 Returns 0 if this method is called on NSNull object.
 */

- (NSUInteger)count;

/**
 Returns NO if this method is called on NSNull object.
 */

- (BOOL)isEqualToString:(NSString *)strTemp;

/**
 Returns NO if this method is called on NSNull object.
 */

- (BOOL)isTrue;

/**
 Returns YES if this method is called on NSNull object.
 */

- (BOOL)isFalse;

/**
 Returns NO if this method is called on NSNull object.
 */

- (BOOL)boolValue;

/**
 Returns NO if this method is called on NSNull object.
 */

- (BOOL)hasPrefix:(NSString *)aString;

/**
 Returns NO if this method is called on NSNull object.
 */

- (BOOL)hasSuffix:(NSString *)aString;

/**
 Returns NSNotFound if this method is called on NSNull object.
 */

- (NSRange)rangeOfString:(NSString *)aString;
@end
