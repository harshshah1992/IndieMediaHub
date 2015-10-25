//
//  RadioButton.m
//  ExpandableTable
//
//  Created by satya on 04/03/15.
//  Copyright (c) 2015 SampleMap. All rights reserved.
//

#import "RadioButton.h"
#import "RadioButtonGroup.h"

@implementation RadioButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

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
        //[self setupInitialSettings];
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds=YES;
    [self setupInitialSettings];
}

-(void)setupInitialSettings {
    //self.groupName = @"Radio";
    [self.imageView setHighlighted:NO];
    if(!self.groupName) {
        self.groupName = @"default";
        
    }
    
    [self addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    RadioButtonGroup *instance = [RadioButtonGroup sharedInstance];
    [instance storeObject:self withGroupName:self.groupName];
    
    
}
-(IBAction)btnSelected:(UIButton *)sender {
    RadioButtonGroup *instance = [RadioButtonGroup sharedInstance];
    NSMutableArray *arrButtons = [instance getButtonsWithGroupName:self.groupName];
    NSArray * arrPrdicateButtons = [NSArray arrayWithArray:arrButtons];
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.isMultipleSelected = YES"];
    arrPrdicateButtons = [arrPrdicateButtons filteredArrayUsingPredicate:predicate];
    if(!arrPrdicateButtons.count) {
    if(sender.selected)
        return;
       [arrButtons setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
    }
    
    self.selected = !self.selected;
    
}

-(NSArray *)getSelectedButton{
    RadioButtonGroup *instance = [RadioButtonGroup sharedInstance];
    NSMutableArray *arrButtons = [instance getButtonsWithGroupName:self.groupName];
//    UIButton *btn;
//    if(arrButtons.count > 0) {
//        for (int i = 0; i < arrButtons.count; i++) {
//            if([[arrButtons objectAtIndex:i] isKindOfClass:[UIButton class]]) {
//                UIButton *button = [arrButtons objectAtIndex:i];
//                if(button.selected) {
//                    btn = button;
//                    break;
//                }
//            }
//        }
//    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.selected = YES"];
    
    return  [arrButtons filteredArrayUsingPredicate:predicate];;
}
-(NSString *)getSelectedTitle {
    if(self.selectedTitle) {
        return self.selectedTitle;
    } else {
        return [self titleForState:UIControlStateNormal];
    }
}
@end
