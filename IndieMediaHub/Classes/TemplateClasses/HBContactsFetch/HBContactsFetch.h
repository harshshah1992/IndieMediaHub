//
//  HBContactsFetch.h
//  HBImagePicker
//
//  Created by Manikanta.Chintapalli on 3/12/15.
//  Copyright (c) 2015 Hidden Brains. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const kFullName = @"full name";
static NSString * const kFirstName = @"first name";
static NSString * const kLastName = @"last name";
static NSString * const kImage = @"image";
static NSString * const kEmails = @"emails";
static NSString * const kPhoneNumbers = @"phone numbers";
static NSString * const kBirthday = @"birthday";
static NSString * const kAddress = @"address";
static NSString * const kCompany = @"company";
typedef void (^ContactsFetchCompletionHandler)(BOOL success, NSMutableArray *arrayContacts);

@interface HBContactsFetch : NSObject

+ (HBContactsFetch*) sharedInstance;
- (void) getAllContactsWithImages:(BOOL)required Completion:(ContactsFetchCompletionHandler)completionHandler;

@end
