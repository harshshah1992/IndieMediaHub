    //
    //  DBaseInteraction.h
    //  AssignmentRubrics
    //
    //  Created by Dimple Panchal on 9/19/12.
    //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
    //

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"
@interface DBaseInteraction : NSObject{
    
}
@property(nonatomic, strong) SQLiteManager *dbManager;
+ (DBaseInteraction *) sharedInstance;

#pragma mark USER
-(NSArray *)getCategoryData :(NSString *)countryId;
-(NSError *)addCategoryData:(NSMutableArray *)aryData forCategory_id:(NSString *)countryId;
-(NSError *)clearCategoryTable:(NSString *)countryId;
//-(NSError *)addTableForCategory:(NSString *)countryId;
-(BOOL)isCategoryTablePresent:(NSString *)countryId;
-(NSArray *)getMandalayHomeData;
-(NSError *)clearHomeDataBase;
-(BOOL)isHomeDataBaseExist;
-(NSError *)addMandalayHomeData:(NSMutableArray *)aryData;
-(NSError *)addUser:(NSMutableDictionary *)userData;
-(NSError *)updateUser:(NSMutableDictionary *)userData;
-(NSArray *)getPdfPathForUserId:(NSMutableDictionary *)userData;
-(NSError *)updateDocumentDetails:(NSMutableDictionary *)DocumentData;
-(NSError *)updatePassword:(NSMutableDictionary *)userData;
-(NSError *)updateFavForDocument:(NSMutableDictionary *)userData;
-(BOOL)validateUser:(NSString *) securityCode;
-(NSArray *)getUserDetailsForUserID:(NSString *) Uid;
-(NSArray *)getThemeDetails;
-(NSArray *)getDocumentsIDForUserId:(NSString *) userid;
-(NSError *)updateSecurityCode:(NSMutableDictionary *)userData;
-(NSError *)deleteWithId:(NSMutableDictionary *)userData;
-(NSArray *)getDetailsWithId:(NSMutableDictionary *)userData;
-(NSArray *)CompleteUsers:(NSMutableDictionary *)details;
-(NSError *)deleteWithName:(NSMutableDictionary *)userData;
-(NSError *)addTableForUser:(NSString *)userData;
-(NSArray*)DataForUserEmailId:(NSString*)userData;
-(NSArray *)insertDataForUser:(NSString*)userData :(NSString*)tableName;
- (NSError *)addDownloadedPdfToDB:(NSMutableDictionary *)userData;
- (NSArray *)getDownloadedPdfForUserId:(NSString *) userid;
#pragma mark Family tree

-(NSArray *)getFamilyRelationships;
-(NSError *)addTreeData:(NSMutableArray *)aryData forAlbumID:(int)iAlbumID;
-(NSArray *)getTreeDataForAlbum:(int)albumID;
-(NSError *)updateTreeDataForAlbum:(int)albumID withData:(NSArray *)aryData;


-(NSError *)createNewAlbum:(NSMutableDictionary *)userData;
-(NSError *)updateAlbumOrder:(NSString *)strOrder:(int)albumID;
-(NSArray *)getUserDetailsForSecurityCode:(NSString *)securityCode;
-(NSArray *)getUserDetailsForEmailid:(NSString *) emailid;
-(BOOL)validateUserEmailId:(NSString *) emailid;
-(int)LastinsertedId;
-(NSArray *)getJournal;
-(NSError *)addJournal:(NSMutableDictionary *)JournalData;
-(NSError *)updateJournal:(NSMutableDictionary *)JournalData;
-(NSArray *)getJournalDetailForJournalId:(int) journalId;
-(NSError *)DeleteJournalForJournalId:(int)journalid;
-(NSError *)addQuickPix:(NSMutableDictionary *)quickPixData;
-(NSError *)UpdateQuickPix:(NSMutableDictionary *)quickPixData;
-(NSArray *)getQuickPix;
-(NSArray *)getQuickPixDetailForQuickPixId:(int) QuickpixId;
-(NSError *)DeleteQuickPixForQuickpixId:(int)quickpixid;
-(NSArray *)getArrayMyalbumData;
-(NSArray *)getDataForAlbumID:(int)albumID;
-(NSError *)DeleteAlbumForAlbumId:(int)albumid;
-(NSError *)updateAlbumDetail:(NSMutableDictionary *)DictEditAlbumData:(int)userId;
-(NSString *)getThemeName:(int)themeId;
-(NSError *)UpdateQuickPixThemeId:(NSMutableDictionary *)quickPixData;
- (NSError *)updateAllUsersValidTill:(NSString *)date;
@end
