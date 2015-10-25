//
//  CustomDateHandler.h
//  HiddenBrains
//
//  Created by Bhargav Narkedamilli on 12/03/15.
//  Copyright (c) 2015 HiddenBrains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDateHandler : NSObject
/* get current date with required format, by passing format and locale if required else nil */
+(NSDate *)getCurrentDatewithFormat:(NSString *)format locale:(NSLocale*)locale;

/* get date from string, by passing datestring with format and locale:if required else nil */
+(NSDate *)getDatefromString:(NSString *)dateString dateFormat:(NSString *)dateFormat locale:(NSLocale*)locale;

/* get date with required format, by passing format and locale if required else nil */
+(NSString *)getStringfromDate:(NSDate *)date dateFormat:(NSString *)dateFormat locale:(NSLocale*)locale;

/* change date formate by passing datestring , oldformat and new formate */
+(NSString *)changeDateformat:(NSString *)dateString  fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat locale:(NSLocale*)locale;

/* get Timestamp for date in seconds by passing date*/
+(NSString *)getTimestampforDate:(NSDate *)date;

/* get Timestamp for current date in seconds */
+(NSString *)timeStampforCurrentDate;

/* get difference in seconds between dates by passing fromDate and toDate */
+(NSInteger)getSecondsDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/* get difference in minutes between 2 dates by passing fromDate and toDate*/
+(NSInteger)getMinutesDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/* get difference in days between 2 dates  by passing fromDate and toDate */
+(NSInteger)getdaysDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/* get difference in months between 2 dates by passing fromDate and toDate */
+(NSInteger)getMonthsDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/* get difference in years between 2 dates by passing fromDate and toDate */
+(NSInteger)getYearsDifferencebetweenfromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;


@end
