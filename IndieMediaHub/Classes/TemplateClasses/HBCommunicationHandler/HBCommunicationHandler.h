//
//  HBCommunicationHandler.h
//  Templete1
//
//  Created by Manikanta on 3/16/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
typedef void (^OpenEmailCompletionHandler)(BOOL success,MFMailComposeResult status);
typedef void (^OpenPhoneNumberCompletionHandler)(BOOL success);
typedef void (^OpenSMSCompletionHandler)(BOOL success,MessageComposeResult status);
@interface HBCommunicationHandler : NSObject<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
+ (HBCommunicationHandler*) sharedInstance;
- (void) openEmailWithSubject:(NSString *)subject withRecipients:(NSArray *)recieptsArray withCc:(NSArray *)ccArray withBcc:(NSArray *)bccArray withBody:(NSString *)body withFooter:(NSString *)footer withHtml:(BOOL)html withCompletion:(OpenEmailCompletionHandler)completionHandler;

- (void) openPhoneWithPhoneNumber:(NSString *)phoneNumber withCompletion:(OpenPhoneNumberCompletionHandler)completionHandler;
- (void) openSMSWithTextMessage:(NSString*)smsText withRecipents:(NSArray*)recipents withCompletion:(OpenSMSCompletionHandler)completionHandler;
@end
