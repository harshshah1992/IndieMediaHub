//
//  CustomImageView.h
//  Custom properties
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface CustomImageView : UIImageView
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable  NSInteger borderRadius;
@property (nonatomic, readwrite) IBInspectable BOOL *canOpenDetailView;
@end
