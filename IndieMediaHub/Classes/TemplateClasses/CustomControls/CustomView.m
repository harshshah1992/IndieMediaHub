//
//  CustomView.m
//  Custom properties
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

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
    [CustomUtility setFontForController:self];
    [CustomUtility setBorderSettingsForController:self];
    if(self.isHeaderView) {
        [self setBackgroundColor:PROJECT_HEADER_BG_COLOR];
    }
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
