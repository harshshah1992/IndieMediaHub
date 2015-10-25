//
//  UIAlertView+MAAlertView.h
//  Custom properties
//
//  Created by Custom properties on 5/12/14.
//  Copyright (c) 2014 Custom properties All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CustomAlertView)
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;


@end
