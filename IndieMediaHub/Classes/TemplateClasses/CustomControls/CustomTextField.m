//
//  CustomTextField.m
//  Custom properties
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

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
    [CustomUtility setBorderSettingsForController:self];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
 }
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
