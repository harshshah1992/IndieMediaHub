//
//  CustomLabel.m
//  Custom properties
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitialSettings];
        
        // Initialization code
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInitialSettings];
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    [self setupInitialSettings];
}

- (void)setupInitialSettings {
    if (self.enableUnderline) {
        [self underlineLabel:self];
    }
    [CustomUtility setBorderSettingsForController:self];
    if (self.isBadgeLabel) {
        [self badgeLabel:self];
    }
}

- (void)underlineLabel:(UILabel*)lbl {
    if (![lbl respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!lbl.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:lbl.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:lbl.attributedText];
    }
    long len = [lbl.text length];
    if (self.underlineColor) {
         [attributedText addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:NSMakeRange(0,len)];
    } else {
        [attributedText addAttribute:NSUnderlineColorAttributeName value:lbl.textColor range:NSMakeRange(0,len)];
    }
   
    
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(0, len)];//Underline color
    
    lbl.attributedText = attributedText;
}

- (void)badgeLabel:(UILabel*)lbl {
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.masksToBounds = YES;
    CGPoint center = self.center;
    CGSize stringSize;
    if (NSFoundationVersionNumber>NSFoundationVersionNumber_iOS_6_1) {
        NSDictionary *attributes = @{NSFontAttributeName: self.font};
        stringSize = [lbl.text sizeWithAttributes:attributes];
    } else {
        stringSize = [lbl.text sizeWithFont:self.font];
    }
    if (stringSize.width<=10) {
        if (stringSize.width == 0) {
            lbl.frame = CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, stringSize.width+15, stringSize.width+15);
            lbl.layer.cornerRadius = (stringSize.width+15)/2;
        }else{
            lbl.frame = CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, stringSize.width+10, stringSize.width+10);
            lbl.layer.cornerRadius = (stringSize.width+10)/2;
        }
    } else {
        lbl.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, stringSize.width, stringSize.width);
        lbl.layer.cornerRadius = stringSize.width/2;
    }
    lbl.center = center;
}

@end
