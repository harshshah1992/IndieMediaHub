//
//  NSString+CustomCategory.h
//  Exception Handling
//
//  Created by Apple IMac on 31/08/13.
//  Copyright (c) 2013 CompanyName All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_CustomCategory)
/**
 Returns YES if current string object value is "yes","true","1", or "on" else retruns NO
 */
- (BOOL)isTrue;

/**
 Returns YES if current string object value is "no","false","0", or "off" else retruns NO
 */

- (BOOL)isFalse;

/**
 Returns MD5 digest string value of current object's value.
 */

- (NSString *)getMD5;

/**
 Returns valid URL encoded string.
 */

- (NSString *)encodedURLString;

/**
 Returns valid URL encoded string withb parameters.
 */

- (NSString *)encodedURLParameterString;

/**
 Returns decoded URL string.
 */

- (NSString *)decodedURLString;

/**
 Returns sring after removing quotation marks(").
 */

- (NSString *)removeQuotes;

/**
 Returns YES if given string is base 64 encoded else NO.
 */

- (BOOL)isBase64Data;
///**
// Returns nil if this method is called on NSString object.
// */
//- (NSString *)valueForKeyPath:(NSString *)key;
/**
 Returns YES if given string caontain HTML tag  else NO.
 */
- (BOOL)isHTMLString;
@end
