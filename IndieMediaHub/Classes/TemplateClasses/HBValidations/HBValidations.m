//
//  HBValidations.m
//  Templete1
//
//  Created by Manikanta on 3/16/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import "HBValidations.h"
@interface HBValidations()
@end
@implementation HBValidations
+(HBValidations*) sharedInstance{
    static dispatch_once_t once;
    static HBValidations * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isEmailValid:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return  [emailTest evaluateWithObject:email];
}

- (BOOL) isStringwithMinChars:(NSString*)string minimumNumberofChars:(int)minValue{

    if((int)[string length] < minValue){
        NSLog(@"no");
        return NO;
    } else {
        NSLog(@"yes");
        return YES;
    }
}

- (BOOL) isStringwithMaxChars:(NSString*)string maximumNumberofChars:(int)maxValue {

    if((int)[string length] > maxValue){
        NSLog(@"no");
        return  NO;
    } else {
        NSLog(@"yes");
        return YES;
    }
}

- (BOOL) isPhoneNumberValid:(NSString*)phoneNumber{
    NSString *phoneRegexWithOutPlus = @"^[0-9]{6,14}$";
    NSString *phoneRegexWithPlus = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTestWithOutPlus = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegexWithOutPlus];
      NSPredicate *phoneTestWithPlus = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegexWithPlus];
    if ([phoneTestWithOutPlus evaluateWithObject:phoneNumber] || [phoneTestWithPlus evaluateWithObject:phoneNumber]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isStringwithOnlyNumbers:(NSString*)string{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *stringText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            return [stringText evaluateWithObject:string];

}

- (BOOL) isStringwithOnlyChars:(NSString*)string {
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *stringText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [stringText evaluateWithObject:string];
}

- (BOOL) isValidUrl:(NSString*)url {
    NSString *urlRegExWithHttp = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSString *urlRegExWithWww =  @"(www\\.)[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
    NSPredicate *urlTestHttp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegExWithHttp];
     NSPredicate *urlTestWww= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegExWithWww];
    if ([urlTestHttp evaluateWithObject:url]||[urlTestWww evaluateWithObject:url]) {
        return YES;
    } else{
        return NO;
    }
}
@end
