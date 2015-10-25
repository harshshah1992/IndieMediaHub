//
//  CustomButton.m
//  Custom properties
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton


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
    self.layer.masksToBounds=YES;
    [self setupInitialSettings];
}

- (void)setupInitialSettings {
    if (self.enableUnderline) {
        [self underlineButton:self];
    }

    [CustomUtility setBorderSettingsForController:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)underlineButton:(UIButton*)btn {
    if (![btn.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!btn.titleLabel.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:btn.titleLabel.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:btn.titleLabel.attributedText];
    }
    long len = [btn.titleLabel.text length];
    if (self.underlineColor) {
        [attributedText addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:NSMakeRange(0,len)];
    } else {
        [attributedText addAttribute:NSUnderlineColorAttributeName value:btn.titleLabel.textColor range:NSMakeRange(0,len)];
    }
    
    
    [attributedText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:1] range:NSMakeRange(0, len)];//Underline color
    
    btn.titleLabel.attributedText = attributedText;
}


@end
