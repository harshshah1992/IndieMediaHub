//
//  CustomUtility.h
//  Custom properties
//
//  Created by PC-27 on 04/06/14.
//  Copyright (c) 2014 Custom properties. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Utils.h"
#import "MBProgressHUD.h"
//#import "TWTAPIManager.h"




@interface CustomUtility : NSObject <UIApplicationDelegate,UITabBarControllerDelegate>
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIView *actionSheetview;


@property (nonatomic, strong) NSString *userProfileImageUrl;
@property (nonatomic, strong) MBProgressHUD *progressHUD;


@property (nonatomic, strong) NSMutableDictionary *objImageCachingDict;

@property (nonatomic, strong) UITabBarController *tabBarController;


@property (nonatomic, strong) UIButton *btnSearchLocation;
@property (nonatomic, strong) UIButton *btnFavourites;

@property (readwrite) BOOL isTabSearchLocationDoubleTapped;
@property (readwrite) BOOL isTabMainMapDoubleTapped;
@property (readwrite) BOOL isTabHomeDoubleTapped;
@property (readwrite) BOOL isTabFavoutitesDoubleTapped;
@property (readwrite) BOOL isMapFromTab;
@property (readwrite) BOOL isHistoryFromTab;



+ (CustomUtility *)sharedInstance;
+ (UIView *)getActionSheet:(id)parentController delegate:(id)pickerClass;
- (void) removeActionSheetFromSuperView;

+ (UITabBarController *)createTabBarController;
+ (id)getViewController:(NSString *)viewController;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIBarButtonItem *)getBarButton:(NSString *)image selectedImage:(NSString *)selectedImage action:(SEL)action target:(id)target;
+ (UIBarButtonItem *)getBarButton:(NSString *)btnname action:(SEL)action target:(id)target;
+ (UIViewController *)getViewControllerFromNavigationController:(UINavigationController *)navController withNibName:(NSString *)nibName;
+ (NSMutableArray *)getArrayBetween:(int)start andEnd:(int)end step:(int)step;
+ (UIPickerView *)getPicker:(NSString *)title target:(id)target;
+ (UIDatePicker *)getDatePicker:(NSString *)title target:(id)target;
+ (UIDatePicker *)getDatePicker:(NSString *)title target:(id)target mode:(UIDatePickerMode)pickerMode ;

+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)getDateFromString:(NSString *)dateString withFormat:(NSString *)format;
+ (NSArray *)getPerPickerDataSource;
-(void)synchronizingUserData:(UIView *)addHUDView;
//Custom properties
//ALERT
+ (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message withCancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonsTitles;

//SESSION
+ (id)getSessionValue:(NSString *)key;
+ (void)saveSessionValue:(id)value withKey:(NSString *)key;
+ (void)removeSessionValue:(NSString *)key ;

//URL AND LOCAL DIR
+(BOOL)isValidUrl:(NSString *)url;
+(BOOL)isDocumentFolderUrl:(NSString *)url;
+(NSString *)getDocumentFolderPathByAppendingPathComponent:(NSString *)fileName;
+ (NSString *)getRandomFilePathWithExtensionInDocumentFolder:(NSString *)extension withPrefix:(NSString *)prefix;
+ (BOOL)saveFileInDocumentFolderAtPath:(NSString *)path andFileData:(NSData *)fileData;
+(NSString *)prepareFileNameWithExtension:(NSString *)extension;


//NILL
+(NSMutableDictionary *)removeNullFromDict:(NSDictionary *)dictionary ;

//APPERENCE
+ (void)setFontForController:(id)controller;
+ (NSString *)getCustomFont:(NSString *)fontName;
+ (void)setBorderSettingsForController:(id)controller;
+ (void)setNavigationBarSettings:(UINavigationController *)navigationController;
//STRING OPERATIONS
+(NSString *)getStringFromBool:(BOOL)boolValue;
+(BOOL)getBoolFromString:(NSString *)stringValue;
+ (NSString *)replaceAllSpecialCharectrs:(NSString *)value;
+ (NSDictionary *)readLocalJsonFileWithName:(NSString *)fileName;
-(CGSize)getSizeforText:(NSString *)message controller:(id)view;
+(CustomButton *)prepareButtonWithText:(NSString *)text withNormalImageName:(NSString *)normImg withSelectedImage:(NSString *)selImg;

+ (UIImage *)imageWithMask:(UIImage *)maskImage originalImage:(UIImage *)originalImage overlayImage:(UIImage *)overlayImage;
+ (UIImage *)imageWithMaskName:(NSString *)maskImage originalImageName:(NSString *)originalImage overlayImageName:(NSString *)overlayImage;
+ (BOOL)validateEmail:(NSString *) emailString;
+ (BOOL) validatePassword:(NSString *) password;
+ (void )getDetailsFromFacebookLogin:(void (^)(id arrayResult ,id accessToken))block;
+(void)getDetailsFromtwitterLogin:(void (^)(id arrayResult,id accessToken))block;

- (void)addProgressHUD :(UIView *) objView;
- (void)removeProgressHUB;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


+ (UIActivityIndicatorView *)getActityIndicatorWithHeight:(int)height andWithWitdth:(int)width;
+ (void)setTabBarimgInsets:(UITabBarController *)tabBarController;
+(NSString*)uniqueIDForDevice;
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (void )underlineLabel:(UILabel*)lbl withInRange:(NSRange)range withColor:(UIColor*)color withStyle:(NSUnderlineStyle)style;


+ (UIImage *)getTabBarImage:(NSString *)imageName;
+ (UITabBarController*)getTabBarController;
+ (void)setPropertiesForToogleGambayButton:(UIButton*)btn;
+ (void)resignKeyBoard:(UIView*)view;

@end
