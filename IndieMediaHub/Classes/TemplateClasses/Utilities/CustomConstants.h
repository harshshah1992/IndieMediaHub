//
//  Constant.h
//  Custom properties
//
//  Created by Custom properties on 24/04/14.
//  Copyright (c) 2014 Custom properties All rights reserved.
//

#ifndef Custom_Constants_h
#define Custom_Constants_h

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define PROJECT_FONT_NAME_NORMAL         @"HelveticaNeue-Light"
#define PROJECT_FONT_NAME_BOLD           @"HelveticaNeue-Bold"
#define PROJECT_FONT_HEADER_SIZE         20

#define PROJECT_HEADER_BG_COLOR [UIColor colorWithRed:35/255.0f green:66/255.0f blue:86/255.0f alpha:1.0]
#define PROJECT_ALERT_TITLE   @"Project Title"
#define REQUEST_TYPE_GET @"GET"
#define REQUEST_TYPE_POST @"POST"
#define FB_APPLICATION_ID  @"Facebook ID" //client Facebook ID
#define PROJECT_BASE_URL @"Local /Online base url"  //local  url
#define DeviceType  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

#define NO_INTERNET_MESSAGE @"No internet connection, please try again later."

#define GPLUS_CLIENT_ID @""

#endif
