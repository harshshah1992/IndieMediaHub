
//
//  CustomLocalization.m
//  ExpandableTable
//
//  Created by satya on 04/03/15.
//  Copyright (c) 2015 SampleMap. All rights reserved.
//

#import "CustomLocalization.h"


@implementation CustomLocalization
static NSBundle *myLocalizedBundle;
+ (CustomLocalization *)sharedInstance {
    static CustomLocalization *utility = nil;
    if (utility == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            utility = [[CustomLocalization alloc] init];
           
        
        });
    }
    [self GetLangKey:[[NSLocale preferredLanguages] objectAtIndex:0]];
   
    return utility;
}

#pragma mark Localization

+(void)GetLangKey:(NSString *)Langkey
{
    NSString *tmpstr=[NSString stringWithFormat:@"%@",[[NSBundle mainBundle]pathForResource:@"LanguageResources" ofType:@"bundle"]];
    tmpstr = [tmpstr stringByAppendingString:@"/"];
    tmpstr = [tmpstr stringByAppendingString:Langkey];
    tmpstr = [tmpstr stringByAppendingString:@".lproj"];
    myLocalizedBundle = [NSBundle bundleWithPath:tmpstr];
}

-(UIImage*)GetLocalImage:(NSString *)ImgName
{
    NSString *filepath = [myLocalizedBundle pathForResource:ImgName ofType:@"png"];
    UIImage *returnImg =[UIImage imageWithContentsOfFile:filepath];
    return returnImg;
}

-(UIImage*)GetLocalImage:(NSString *)ImgName Type:(NSString *)imgType
{
    NSString *filepath = [myLocalizedBundle pathForResource:ImgName ofType:imgType];
    UIImage *returnImg = [UIImage imageWithContentsOfFile:filepath];
    return returnImg;
}

-(NSString *)getLocalvalue:(NSString*)Key
{
    NSString *localValue = NSLocalizedStringFromTableInBundle(Key,@"Localized",myLocalizedBundle,@"");
    return localValue;

}





@end
