//
//  NSNull+CustomCategory.m
//  Exception Handling
//
//  Created by Apple IMac on 07/06/13.
//  Copyright (c) 2013 companyName All rights reserved.
//

#import "NSNull+CustomCategory.h"

@implementation NSNull (NSNull_CustomCategory)
- (BOOL)length {
    return 0;
}
- (NSString *)uppercaseString {
    return [NSString stringWithFormat:@""];
}
- (NSString *)lowercaseString {
  return [NSString stringWithFormat:@""];  
}
- (NSUInteger)count {
    return 0;
}
- (BOOL)isEqualToString:(NSString *)strTemp {
    return NO;
}
- (BOOL)isTrue {
    return NO;
}
- (BOOL)isFalse {
    return YES;
}
- (BOOL)boolValue {
    return NO;
}
- (BOOL)hasPrefix:(NSString *)aString {
    return NO;
}
- (BOOL)hasSuffix:(NSString *)aString {
    return NO;
}
- (NSRange)rangeOfString:(NSString *)aString {
    return NSMakeRange(NSNotFound, 0);
}

@end
