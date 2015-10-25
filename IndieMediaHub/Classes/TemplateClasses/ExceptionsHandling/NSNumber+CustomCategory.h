//
//  NSNumber+CustomCategory.h
//  Exception Handling
//
//  Created by Apple IMac on 14/08/13.
//  Copyright (c) 2013 CompanyName All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  NSNumber (NSNumber_CustomCategory)

/**
 Returns 0 if this is method is called on NSNumber object.
 */

- (NSInteger)length;

/**
 Returns NO if this is method is called on NSNumber object.
 */

- (BOOL)isEqualToString:(id)strTemp;

/**
 Returns 0 length string if this is method is called on NSNumber object.
 */

- (NSString *)uppercaseString;

/**
 Returns 0 length string if this is method is called on NSNumber object.
 */

- (NSString *)lowercaseString;

/**
 Returns NO if this is method is called on NSNumber object.
 */

- (BOOL)isTrue;

/**
 Returns YES if this is method is called on NSNumber object.
 */

- (BOOL)isFalse;

/**
 Returns NO if this is method is called on NSNumber object.
 */

- (BOOL)hasPrefix:(NSString *)aString;

/**
 Returns NO if this is method is called on NSNumber object.
 */

- (BOOL)hasSuffix:(NSString *)aString;

/**
 Returns NSNotFound if this is method is called on NSNumber object.
 */

- (NSRange)rangeOfString:(NSString *)aString;

/**
 Returns 0 length string if this is method is called on NSNumber object.
 */

- (NSString *)encodedURLParameterString;
@end
