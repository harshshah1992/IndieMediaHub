//
//  HBContactsFetch.m
//  HBImagePicker
//
//  Created by Manikanta.Chintapalli on 3/12/15.
//  Copyright (c) 2015 Hidden Brains. All rights reserved.
//

#import "HBContactsFetch.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface HBContactsFetch()<ABPeoplePickerNavigationControllerDelegate>
@property (nonatomic , strong) ContactsFetchCompletionHandler contactsFetchCompletionHandler;
@end

@implementation HBContactsFetch

+(HBContactsFetch*) sharedInstance{
    static dispatch_once_t once;
    static HBContactsFetch * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void) getAllContactsWithImages:(BOOL)required Completion:(ContactsFetchCompletionHandler)completionHandler {
    self.contactsFetchCompletionHandler = [completionHandler copy];
    [self getAllContacts:required];
    
}

- (void)getAllContacts:(BOOL)required
{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        NSMutableArray* contacts = [NSMutableArray arrayWithCapacity:nPeople];
        
        for (int i = 0; i < nPeople; i++) {
            NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name and Last Name
            NSString *strFirstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            
            NSString *strLastName =  (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
            
            if (!strFirstName) {
                strFirstName = @"";
            }
            if (!strLastName) {
                strLastName = @"";
            }
            [contact setObject:strFirstName forKey:kFirstName];
            [contact setObject:strLastName forKey:kLastName];
            [contact setObject:[NSString stringWithFormat:@"%@ %@",strFirstName,strLastName] forKey:kFullName];

            // get contacts picture, if pic doesn't exists, show standart one
            if (required) {
                NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
                UIImage *image = [UIImage imageWithData:imgData];
                if (!image) {
                    image = [UIImage imageNamed:@"NoImg.png"];
                }
                [contact setObject:image forKey:kImage];
            }
            

            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for(CFIndex i=0;i<ABMultiValueGetCount(multiPhones);i++) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
            }
            
            if ([phoneNumbers count]) {
                [contact setObject:phoneNumbers forKey:kPhoneNumbers];
            }else {
                [phoneNumbers addObject:@"no phone number"];
                [contact setObject:phoneNumbers forKey:kPhoneNumbers];
            }
            
            //get Contact email
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                NSString *contactEmail = (__bridge NSString *)contactEmailRef;
                if (contactEmail == nil) {
                    contactEmail = @"no email";
                }
                [contactEmails addObject:contactEmail];
            }
           
            if ([contactEmails count]) {
                [contact setObject:contactEmails forKey:kEmails];
            } else {
                [contactEmails addObject:@"no email address"];
                [contact setObject:contactEmails forKey:kEmails];
            }
            
            
            //get Birthday
            NSString *strBirthday = (__bridge NSString*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
            if (strBirthday == nil) {
                strBirthday = @"no birthday entered";
            }
            [contact setObject:strBirthday forKey:kBirthday];
            
            //get Company
            NSString *strCompany = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
            if (strCompany == nil) {
                strCompany = @"no company";
            }
            [contact setObject:strCompany forKey:kCompany];
            
            //get Address
            
            ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
            NSMutableArray *personAddress = [[NSMutableArray alloc] init];
            for(CFIndex j = 0; j < ABMultiValueGetCount(address); j++)
            {
                CFDictionaryRef addressDict = ABMultiValueCopyValueAtIndex(address, j);
                NSMutableDictionary *addresses = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary *)(addressDict)];
            
                [personAddress addObject:addresses];
            }
            if ([personAddress count]) {
               [contact setObject:personAddress forKey:kAddress];
            } else {
                [contactEmails addObject:@"no address"];
                [contact setObject:personAddress forKey:kAddress];
            }
            
            [contacts addObject:contact];
        }
        self.contactsFetchCompletionHandler(YES, contacts);
        self.contactsFetchCompletionHandler = nil;
        
    } else {
        self.contactsFetchCompletionHandler(NO, nil);
        self.contactsFetchCompletionHandler = nil;
    }
}
@end
