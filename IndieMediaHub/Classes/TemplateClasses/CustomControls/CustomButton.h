//
//  CustomButton.h
//  CustomIOS
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomButton : UIButton
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable  NSInteger borderRadius;
@property (nonatomic) IBInspectable BOOL enableUnderline;
@property (nonatomic) IBInspectable UIColor *underlineColor;
@end
