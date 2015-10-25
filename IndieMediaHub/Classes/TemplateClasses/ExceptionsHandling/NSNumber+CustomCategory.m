//
//  NSNumber+CustomCategory.m
//  Exception Handling
//
//  Created by Apple IMac on 14/08/13.
//  Copyright (c) 2013 CompanyName All rights reserved.
//

#import "NSNumber+CustomCategory.h"

@implementation NSNumber (NSNumber_CustomCategory)
- (NSInteger)length {
    return [[self stringValue] length];
}
- (BOOL)isEqualToString:(id)strTemp {
    if ([strTemp isKindOfClass:[NSString class]]) {
        return [[self stringValue] isEqualToString:strTemp];
    } else if ([strTemp isKindOfClass:[NSNumber class]]) {
        return [[self stringValue] isEqualToString:[strTemp stringValue]];
    }
    return NO;
}
- (NSString *)uppercaseString {
    return [[self stringValue] uppercaseString];
}
- (NSString *)lowercaseString {
    return [[self stringValue] lowercaseString];
}
- (BOOL)isTrue {
    return ([[self lowercaseString] isEqualToString:@"1"] || [[self lowercaseString] isEqualToString:@"yes"] || [[self lowercaseString] isEqualToString:@"true"] || [[self lowercaseString] isEqualToString:@"on"]);
}
- (BOOL)isFalse {
    return ([self length] == 0 || [[self lowercaseString] isEqualToString:@"0"] || [[self lowercaseString] isEqualToString:@"no"] || [[self lowercaseString] isEqualToString:@"false"] || [[self lowercaseString] isEqualToString:@"off"]);
}
- (BOOL)hasPrefix:(NSString *)aString {
    return [[self stringValue] hasPrefix:aString];
}
- (BOOL)hasSuffix:(NSString *)aString {
    return [[self stringValue] hasSuffix:aString];
}
- (NSRange)rangeOfString:(NSString *)aString {
    return [[self stringValue] rangeOfString:aString];
}
- (NSString *)encodedURLParameterString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)[self stringValue],
                                                                                             NULL,
                                                                                             CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

@end
