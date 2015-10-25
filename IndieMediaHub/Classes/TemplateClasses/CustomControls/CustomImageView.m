//
//  CustomImageView.m
//  Custom properties
//
//  Created by Custom properties on 6/11/14.
//  Copyright (c) 2014 Custom properties.com All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

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
    if (self.canOpenDetailView) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDetailView)];
        [self addGestureRecognizer:tap];
    }
    [CustomUtility setBorderSettingsForController:self];
}

- (void) openDetailView {
    UIView *viewImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UIImageView *imgDetailView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgDetailView.image = self.image;
    [viewImage addSubview:imgDetailView];
    UIButton *btnStop = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 100, 44)];
    [btnStop  setImage:[UIImage imageNamed:@"close-icon.png"] forState:UIControlStateNormal];
    btnStop.center = CGPointMake([UIScreen mainScreen].bounds.size.width-22, 50);
    [btnStop addTarget:self action:@selector(dismissDetailView) forControlEvents:UIControlEventTouchUpInside];
    [viewImage addSubview:btnStop];
    UIViewController *controller = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    [controller.view addSubview:viewImage];
}
- (void) dismissDetailView {
    
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
