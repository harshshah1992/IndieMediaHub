//
//  CustomLocalization.h
//  ExpandableTable
//
//  Created by satya on 04/03/15.
//  Copyright (c) 2015 SampleMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomLocalization : NSObject

+ (CustomLocalization *)sharedInstance;
-(UIImage*)GetLocalImage:(NSString *)ImgName;
-(UIImage*)GetLocalImage:(NSString *)ImgName Type:(NSString *)imgType;
-(NSString *)getLocalvalue:(NSString*)Key;


@end
