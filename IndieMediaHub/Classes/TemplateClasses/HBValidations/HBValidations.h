//
//  HBValidations.h
//  Templete1
//
//  Created by Manikanta on 3/16/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBValidations : NSObject
+ (HBValidations*) sharedInstance;
- (BOOL) isEmailValid:(NSString*)email;
- (BOOL) isPhoneNumberValid:(NSString*)phoneNumber;
- (BOOL) isStringwithMinChars:(NSString*)string minimumNumberofChars:(int)minValue;

- (BOOL) isStringwithMaxChars:(NSString*)string maximumNumberofChars:(int)maxValue;
- (BOOL) isStringwithOnlyNumbers:(NSString*)string;
- (BOOL) isStringwithOnlyChars:(NSString*)string ;
- (BOOL) isValidUrl:(NSString*)url;
@end
