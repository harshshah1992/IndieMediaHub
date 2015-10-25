//
//  HBCommunicationHandler.m
//  Templete1
//
//  Created by Manikanta on 3/16/15.
//  Copyright (c) 2015 com.CompanyName. All rights reserved.
//

#import "HBCommunicationHandler.h"
@interface HBCommunicationHandler(){

    
}

@property (strong , nonatomic) OpenEmailCompletionHandler openEmailCompletionHandler;
@property (strong , nonatomic) OpenPhoneNumberCompletionHandler openPhoneNumberCompletionHandler;
@property (strong , nonatomic) OpenSMSCompletionHandler openSMSCompletionHandler;

@end

@implementation HBCommunicationHandler
+(HBCommunicationHandler*) sharedInstance{
    static dispatch_once_t once;
    static HBCommunicationHandler * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma email handling
- (void) openEmailWithSubject:(NSString *)subject withRecipients:(NSArray *)recieptsArray withCc:(NSArray *)ccArray withBcc:(NSArray *)bccArray withBody:(NSString *)body withFooter:(NSString *)footer withHtml:(BOOL)html withCompletion:(OpenEmailCompletionHandler)completionHandler {
    //Pop up the email picker
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:subject];
    [picker setToRecipients:recieptsArray];
    [picker setCcRecipients:ccArray];
    [picker setBccRecipients:bccArray];
    [picker setMessageBody:[NSString stringWithFormat:@"%@%@",body,footer] isHTML:html];
    picker.navigationBar.barStyle = UIBarStyleDefault;
    UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
    [controller presentViewController:picker animated:YES completion:^{
        self.openEmailCompletionHandler = [completionHandler copy];
    }];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            self.openEmailCompletionHandler(NO,MFMailComposeResultCancelled);
            break;
        case MFMailComposeResultSaved:
            self.openEmailCompletionHandler(YES,MFMailComposeResultSaved);
            break;
        case MFMailComposeResultSent:
            self.openEmailCompletionHandler(YES,MFMailComposeResultSent);
            break;
        case MFMailComposeResultFailed:
            self.openEmailCompletionHandler(NO,MFMailComposeResultFailed);
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            self.openEmailCompletionHandler(NO,MFMailComposeResultFailed);
        }
            
            break;
    }
    UIViewController *controllerView = [[UIApplication sharedApplication].delegate window].rootViewController;
    [controllerView dismissViewControllerAnimated:YES completion:^{
        self.openEmailCompletionHandler = nil;
    }];
}

#pragma call handling
- (void) openPhoneWithPhoneNumber:(NSString *)phoneNumber withCompletion:(OpenPhoneNumberCompletionHandler)completionHandler {
    self.openPhoneNumberCompletionHandler = [completionHandler copy];
    NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
    if([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        [[UIApplication sharedApplication] openURL:phoneURL];
        self.openPhoneNumberCompletionHandler(YES);
    } else {
        self.openPhoneNumberCompletionHandler(NO);
    }
    self.openPhoneNumberCompletionHandler = nil;
}

#pragma sms handling
- (void) openSMSWithTextMessage:(NSString*)smsText withRecipents:(NSArray*)recipents withCompletion:(OpenSMSCompletionHandler)completionHandler{
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:smsText];
    
    // Present message view controller on screen
    UIViewController *controller = [[UIApplication sharedApplication].delegate window].rootViewController;
    [controller presentViewController:messageController animated:YES completion:^{
        self.openSMSCompletionHandler = [completionHandler copy];
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            self.openSMSCompletionHandler(NO, MessageComposeResultCancelled);
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            self.openSMSCompletionHandler(NO, MessageComposeResultFailed);
            break;
        }
            
        case MessageComposeResultSent:
             self.openSMSCompletionHandler(YES, MessageComposeResultSent);
            break;
            
        default:
            break;
    }
    UIViewController *viewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    [viewController dismissViewControllerAnimated:YES completion:^{
        self.openSMSCompletionHandler = nil;
    }];
}
@end
