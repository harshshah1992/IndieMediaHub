//
//  RadioButtonGroup.m
//  ExpandableTable
//
//  Created by satya on 04/03/15.
//  Copyright (c) 2015 SampleMap. All rights reserved.
//

#import "RadioButtonGroup.h"
#import <UIKit/UIKit.h>


@implementation RadioButtonGroup
static NSMutableDictionary *arrButtonGroups;
+ (RadioButtonGroup*)sharedInstance {
    static RadioButtonGroup *utility = nil;
    if (utility == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            utility = [[RadioButtonGroup alloc] init];
            arrButtonGroups = [[NSMutableDictionary alloc] init];
        });
    }
    
    return utility;
}

-(void)storeObject:(CustomButton *)button withGroupName:(NSString *)gruopName {
    [self releaseUnRefferencedButtons];
    NSMutableArray *arr = [arrButtonGroups objectForKey:gruopName];
    if(arr) {
      if(![arr containsObject:button])
        [arr addObject:button];
    } else {
        arr = [[NSMutableArray alloc] init];
        
          [arr addObject:button];
    }
    [arrButtonGroups setObject:arr forKey:gruopName];
}

-(NSMutableArray *)getButtonsWithGroupName:(NSString *)groupName {
    NSMutableArray *arr = [arrButtonGroups objectForKey:groupName];
    if(!arr) {
         arr = [[NSMutableArray alloc] init];
    }
    
    return arr;
}


-(void)releaseUnRefferencedButtons {
    
    for (NSString *key in arrButtonGroups.allKeys) {
        NSMutableArray *arrButtons  = [arrButtonGroups objectForKey:key];
        NSMutableArray *unReferencedButtons = [[NSMutableArray alloc] init];
        for (UIButton * btn in arrButtons) {
            if(!btn.superview) {
                [unReferencedButtons addObject:btn];
            }
        }
        
        for (UIButton * btn in unReferencedButtons) {
            [arrButtons removeObject:btn];
        }
        
        unReferencedButtons = nil;
        
        [arrButtonGroups setObject:arrButtons forKey:key];
    }
}

@end
