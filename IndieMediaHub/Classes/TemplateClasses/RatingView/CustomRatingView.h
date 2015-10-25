//
//  CustomRatingView.h
//  DemoNotifications
//
//  Created by satya on 22/06/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomRatingView : UIControl {
    CALayer *_starMaskLayer;
    CALayer *_highlightLayer;
    UIImage *_markImage;
}
@property (nonatomic) NSUInteger numberOfStar;
@property (copy, nonatomic) NSString *markCharacter;
@property (strong, nonatomic) UIFont *markFont;
@property (strong, nonatomic) UIImage *markImage;
@property (strong, nonatomic) UIColor *baseColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (nonatomic) float value;
@property (nonatomic) float stepInterval;

@end
