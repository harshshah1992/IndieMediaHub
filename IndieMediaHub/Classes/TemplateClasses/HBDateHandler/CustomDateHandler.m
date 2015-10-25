//
//  CustomDateHandler.m
//  HiddenBrains
//
//  Created by Bhargav Narkedamilli on 12/03/15.
//  Copyright (c) 2015 HiddenBrains. All rights reserved.
//

#import "CustomDateHandler.h"

@implementation CustomDateHandler

+(NSDate *)getDatefromString:(NSString *)dateString dateFormat:(NSString *)dateFormat locale:(NSLocale*)locale {
    NSDateFormatter * dateFormatterForDate=[[NSDateFormatter alloc]init];
    [dateFormatterForDate setDateFormat:dateFormat];
    if (locale) {
        [dateFormatterForDate setLocale:locale];
    }
    NSDate *date=[dateFormatterForDate dateFromString:dateString];
    return date;
}

+(NSString *)getStringfromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
                        locale:(NSLocale*)locale {
    NSDateFormatter * dateFormatterForDate=[[NSDateFormatter alloc]init];
    [dateFormatterForDate setDateFormat:dateFormat];
    if (locale) {
        [dateFormatterForDate setLocale:locale];
    }
    NSString *strDate =[dateFormatterForDate stringFromDate:date];
    return strDate;
}

+(NSDate *)getCurrentDatewithFormat:(NSString *)format locale:(NSLocale*)locale {
    NSDateFormatter *dateFormatterForDate = [[NSDateFormatter alloc] init];
    [dateFormatterForDate setDateFormat:format];
    if (locale) {
        [dateFormatterForDate setLocale:locale];
    }
    NSString *strTime = [dateFormatterForDate stringFromDate:[NSDate date]];
    NSDate *date = [dateFormatterForDate dateFromString:strTime];
    return date;
}
+(NSString *)changeDateformat:(NSString *)dateString  fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat locale:(NSLocale*)locale {
    
    NSDate *oldFormattedDate = [self getDatefromString:dateString dateFormat:oldFormat locale:locale];
    return  [self getStringfromDate:oldFormattedDate dateFormat:newFormat locale:locale];
}


+(NSString *)getTimestampforDate:(NSDate *)date {
    return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
}

+(NSString *)timeStampforCurrentDate{
    return [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
}

+(NSInteger)getSecondsDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *currentcalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentcalendar components:NSSecondCalendarUnit
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    return [components second];
}

+(NSInteger)getMinutesDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *currentcalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentcalendar components:NSMinuteCalendarUnit
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    return [components minute];

}

+(NSInteger)getdaysDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
   
   NSCalendar *currentcalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentcalendar components:NSDayCalendarUnit
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    return [components day];
    
}

+(NSInteger)getYearsDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *currentcalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentcalendar components:NSYearCalendarUnit
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    return [components year];
    
}

+(NSInteger)getMonthsDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    NSCalendar *currentcalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentcalendar components:NSMonthCalendarUnit
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:0];
    return [components month];
    
}



@end
