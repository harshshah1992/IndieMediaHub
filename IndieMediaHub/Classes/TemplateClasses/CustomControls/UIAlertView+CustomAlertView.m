//
//  UIAlertView+SCAlertView.m
//  Custom properties
//
//  Created by Custom properties on 5/12/14.
//  Copyright (c) 2014 Custom properties All rights reserved.
//

#import "UIAlertView+CustomAlertView.h"
#import <objc/runtime.h>
@interface SCAlertViewWrapper : NSObject
@property (copy) void(^completionBlock)(UIAlertView *alertView, NSInteger buttonIndex);
@end
@implementation SCAlertViewWrapper
#pragma mark - UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.completionBlock)
        
        self.completionBlock(alertView, buttonIndex);
}
// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.

// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView {
    
    // Just simulate a cancel button click
    
    if (self.completionBlock)
        
        self.completionBlock(alertView, alertView.cancelButtonIndex);
}
@end
static const char kSCAlertViewWrapper;
@implementation UIAlertView (CustomAlertView)
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion {
    SCAlertViewWrapper *alertWrapper = [[SCAlertViewWrapper alloc] init];
    alertWrapper.completionBlock = completion;
    self.delegate = alertWrapper;
    // Set the wrapper as an associated object
    objc_setAssociatedObject(self, &kSCAlertViewWrapper, alertWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // Show the alert as normal
    [self show];
    
}
@end
