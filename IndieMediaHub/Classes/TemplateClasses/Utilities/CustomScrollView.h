//
// CustomScrollView.h
//  Custom properties
//
//  Created by PC-27 on 05/06/14.
//  Copyright (c) 2014 Custom properties. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

@interface CustomScrollView : UIScrollView <UITextFieldDelegate, UITextViewDelegate>
- (void)contentSizeToFit;
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end
