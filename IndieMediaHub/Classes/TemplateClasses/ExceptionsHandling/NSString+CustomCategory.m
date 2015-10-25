//
//  NSString+CustomCategory.m
//  Exception Handling
//
//  Created by Apple IMac on 31/08/13.
//  Copyright (c) 2013 CompanyName All rights reserved.
//

#import "NSString+CustomCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSString_CustomCategory)
- (BOOL)isTrue {
    return ([[self lowercaseString] isEqualToString:@"1"] || [[self lowercaseString] isEqualToString:@"yes"] || [[self lowercaseString] isEqualToString:@"true"] || [[self lowercaseString] isEqualToString:@"on"]);
}
- (BOOL)isFalse {
    return ([self length] == 0 || [[self lowercaseString] isEqualToString:@"0"] || [[self lowercaseString] isEqualToString:@"no"] || [[self lowercaseString] isEqualToString:@"false"] || [[self lowercaseString] isEqualToString:@"off"]);
}
- (NSString *)getMD5 {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x",result[i]];
    }
    return resultStr;
}
- (NSString *)encodedURLString {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,                   // characters to leave unescaped (NULL = all escaped sequences are replaced)
                                                                                             CFSTR("?=&+"),          // legal URL characters to be escaped (NULL = all legal characters are replaced)
                                                                                             kCFStringEncodingUTF8)); // encoding
	return result;
}

- (NSString *)encodedURLParameterString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

- (NSString *)decodedURLString {
	NSString *result = (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                            (CFStringRef)self,
                                                                                                            CFSTR(""),
                                                                                                            kCFStringEncodingUTF8));
	
	return result;
	
}

- (NSString *)removeQuotes
{
	NSUInteger length = [self length];
	NSString *ret = self;
	if ([self characterAtIndex:0] == '"') {
		ret = [ret substringFromIndex:1];
	}
	if ([self characterAtIndex:length - 1] == '"') {
		ret = [ret substringToIndex:length - 2];
	}
	
	return ret;
}
- (BOOL)isBase64Data
{
    NSString *input = self;
    if([input length] == 0 || [input isEqualToString:@"null"]) {
        return NO;
    }
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}
//- (NSString *)valueForKeyPath:(NSString *)key {
//    return nil;
//}
- (BOOL)isHTMLString {
    return ([self rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch].location == NSNotFound)? NO:YES;
}
@end
