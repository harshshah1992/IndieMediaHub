//
//  RadioButtonGroup.h
//  ExpandableTable
//
//  Created by satya on 04/03/15.
//  Copyright (c) 2015 SampleMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface RadioButtonGroup : NSObject
+ (RadioButtonGroup*)sharedInstance ;
-(void)storeObject:(CustomButton *)button withGroupName:(NSString *)gruopName;
-(NSMutableArray *)getButtonsWithGroupName:(NSString *)groupName;
@end
