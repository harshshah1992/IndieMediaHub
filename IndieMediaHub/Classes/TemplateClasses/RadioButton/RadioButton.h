//
//  RadioButton.h
//  ExpandableTable
//
//  Created by satya on 04/03/15.
//  Copyright (c) 2015 SampleMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : CustomButton

@property (nonatomic ,strong) NSString *groupName;
@property (nonatomic ,strong) NSString *selectedTitle;
@property (readwrite) BOOL isMultipleSelected;

-(NSString *)getSelectedTitle;
-(NSArray *)getSelectedButton;
@end
