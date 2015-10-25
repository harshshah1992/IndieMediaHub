        //
    //  DBaseInteraction.m
    //  AssignmentRubrics
    //
    //  Created by Dimple Panchal on 9/19/12.
    //  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
    //

#import "DBaseInteraction.h"

@implementation DBaseInteraction
@synthesize dbManager = _dbManager;
static DBaseInteraction *sharedInstance = nil;

+(DBaseInteraction *) sharedInstance; 
{
    if(!sharedInstance) {
		sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

-(SQLiteManager *)dbManager{
    if(!_dbManager) {
        _dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"Raymonds_lookup.sqlite"];
    [_dbManager openDatabase];
    [_dbManager closeDatabase];
    }
    return _dbManager;
}

#pragma mark USER
//for categery db
//-(NSError *)addTableForCategory:(NSString *)countryId
//{
//    NSString *strQuery = [NSString stringWithFormat:@"CREATE  TABLE '%@' (name TEXT, subcategory_id TEXT)",countryId];
//    NSError *error = [self.dbManager doQuery:strQuery];
//    return error;
//}
-(BOOL)isCategoryTablePresent:(NSString *)countryId {
    NSString *strQuery=[NSString stringWithFormat:@"SELECT * FROM subCategoryData WHERE category_id='%@'",countryId];
    NSArray *data=[self.dbManager getRowsForQuery:strQuery];
    if ([data count] > 0) {
        return YES;
    }else {
        return NO;
    }
}
-(NSError *)clearCategoryTable:(NSString *)countryId {
    NSString *strQuery=[NSString stringWithFormat:@"DELETE  FROM subCategoryData WHERE category_id='%@'",countryId];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
    
}

-(NSError *)addCategoryData:(NSMutableArray *)aryData forCategory_id:(NSString *)countryId {
    NSString *strQuery = @"";
    NSError *error = nil;
    for(int i = 0 ; i<[aryData count]; i++){
        strQuery = [NSString stringWithFormat:@"INSERT INTO subCategoryData (category_id, name, subcategory_id) VALUES ('%@', '%@', '%@')",
                    
                    countryId,
                    [[aryData objectAtIndex:i] objectForKey:@"name"],
                    [[aryData objectAtIndex:i] objectForKey:@"subcategory_id"]];
        error  = [self.dbManager doQuery:strQuery];
    }
    return error;
}

-(NSArray *)getCategoryData :(NSString *)countryId{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM subCategoryData WHERE category_id='%@'",countryId ];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

//for home db
-(BOOL)isHomeDataBaseExist {
    NSString *strQuery=[NSString stringWithFormat:@"SELECT * FROM MandalayHomeData"];
    NSArray *data=[self.dbManager getRowsForQuery:strQuery];
    if ([data count] > 0) {
        return YES;
    }else {
        return NO;
    }
    
}
-(NSError *)clearHomeDataBase {
    NSString *strQuery=[NSString stringWithFormat:@"DELETE  FROM MandalayHomeData"];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;

}
-(NSError *)addMandalayHomeData:(NSMutableArray *)aryData {
    NSString *strQuery = @"";
    NSError *error = nil;
    for(int i = 0 ; i<[aryData count]; i++){
        strQuery = [NSString stringWithFormat:@"INSERT INTO MandalayHomeData ( category_id, image_location, name) VALUES ( %d, '%@', '%@')",
                    
                    [[[aryData objectAtIndex:i] objectForKey:@"category_id"] intValue],
                    [[aryData objectAtIndex:i] objectForKey:@"image_location"],
                    [[aryData objectAtIndex:i] objectForKey:@"name"]];
        error  = [self.dbManager doQuery:strQuery];
    }
    return error;
}

-(NSArray *)getMandalayHomeData{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM MandalayHomeData" ];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}


-(NSError *)addUser:(NSMutableDictionary *)userData
{
    
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO ma_userDetails (vUser_Name,vEmail_Id,vPassword,vValid_Till,tUser_iD) VALUES ('%@','%@','%@','%@','%@')",
                          [userData objectForKey:@"vUser_Name"],
                          [userData objectForKey:@"vEmail_Id"],
                          [userData objectForKey:@"vPassword"],
                            [userData objectForKey:@"vValid_Till"],
                          [userData objectForKey:@"tUser_iD"]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;    
}

-(NSError *)addDownloadedPdfToDB:(NSMutableDictionary *)userData
{
//    NSString *strDateNTime = [NSString stringWithFormat:@"%f",[NSTimeInterval ]]
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *TimeInterval = [dateFormatter stringFromDate:[NSDate date]] ;
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO localdoc (tLocaldocId,tDocumentId,tUserId,tCategoryname,tSubcategoryname,tTitle,tDocUrl,tIsFavorite,tFilePath,DateNTime) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                          [userData objectForKey:@"tLocaldocId"],
                          [userData objectForKey:@"tDocumentId"],
                          [userData objectForKey:@"tUserId"],
                          [userData objectForKey:@"tCategoryname"],
                          [userData objectForKey:@"tSubcategoryname"],
                          [userData objectForKey:@"tTitle"],
                          [userData objectForKey:@"tDocUrl"],
                          [userData objectForKey:@"tIsFavorite"],
                          [userData objectForKey:@"tFilePath"],
                          TimeInterval];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}


-(NSArray *)getDownloadedPdfForUserId:(NSString *) userid{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM localdoc Where tUserId='%@' order by tTitle", userid ];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}
-(NSArray *)getPdfPathForUserId:(NSMutableDictionary *)userData{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT tFilePath,DateNTime FROM localdoc WHERE tUserId = '%@' AND tDocumentId = '%@'",
                          [userData objectForKey:@"tUserId"],
                          [userData objectForKey:@"tDocumentId"]];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}


-(NSArray *)getDocumentsIDForUserId:(NSString *) userid{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT tDocumentId FROM localdoc Where tUserId='%@'", userid ];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSError *)updateFavForDocument:(NSMutableDictionary *)userData
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE localdoc SET tIsFavorite = '%@' WHERE tUserId = '%@' AND tDocumentId = '%@'",
                          
                          [userData objectForKey:@"tIsFavorite"],
                          [userData objectForKey:@"tUserId"],
                          [userData objectForKey:@"tDocumentId"]];
    
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}



-(NSError *)addTableForUser:(NSString *)userData
{
    
    NSString *strQuery = [NSString stringWithFormat:@"CREATE  TABLE '%@' (sno INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , data VARCHAR)",userData];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSArray*)DataForUser:(NSString*)userData
{
    NSString *strQuery=[NSString stringWithFormat:@"SELECT * FROM '%@'",userData];
    NSArray *error = [self.dbManager getRowsForQuery:strQuery];
    return error;
}

-(NSError *)insertDataForUser:(NSString*)userData :(NSString*)tableName;
{
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO '%@' (data) VALUES ('%@')",tableName,userData];
                         
      NSError *error = [self.dbManager doQuery:strQuery];
      return error;
}




-(NSError *)deleteWithId:(NSMutableDictionary *)userData
{
    NSString *strQuery=[NSString stringWithFormat:@"DELETE  FROM localdoc WHERE tUserId = '%@' AND tDocumentId = '%@'",
                        [userData objectForKey:@"iUser_id"],
                        [userData objectForKey:@"tDocumentId"]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSError *)deleteWithName:(NSMutableDictionary *)userData
{
    NSString *strQuery=[NSString stringWithFormat:@"DELETE FROM iUser_details WHERE iUser_name = '%@'",
                        [userData objectForKey:@"iUser_name"]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}


-(NSArray *)getUserDetailsForUserID:(NSString *) Uid{
    
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM ma_userDetails Where tUser_iD='%@'",Uid];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSArray *)getDetailsWithId:(NSMutableDictionary *)userData
{
    NSString *strQuery=[NSString stringWithFormat:@"SELECT * FROM iUser_details WHERE iUser_id = '%d'",
                        [[userData objectForKey:@"iUser_id"]intValue]];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}
-(NSArray *)CompleteUsers:(NSMutableDictionary *)details
{
    NSString *strQuery=[NSString stringWithFormat:@"SELECT * FROM iUser_details"];
    NSArray *data=[self.dbManager getRowsForQuery:strQuery];
    return data;
}



-(NSError *)updateSecurityCode:(NSMutableDictionary *)userData
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE User SET vSecurityCode = '%@' WHERE iUserId = '%d'",[userData objectForKey:@"vSecurityCode"],[[userData objectForKey:@"iUserId"] intValue]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSArray *)getUserDetailsForSecurityCode:(NSString *) securityCode{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT iUserId  FROM User Where vSecurityCode='%@'", securityCode ];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSError *)updateUser:(NSMutableDictionary *)userData
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE ma_userDetails SET vUser_Name = '%@',vPassword = '%@',vValid_Till = '%@',tUser_iD = '%@' WHERE vEmail_Id = '%@'",
                          
                          [userData objectForKey:@"vUser_Name"],
                          [userData objectForKey:@"vPassword"],
                          [userData objectForKey:@"vValid_Till"],
                          [userData objectForKey:@"tUser_iD"],
                          [userData objectForKey:@"vEmail_Id"]];
    
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSError *)updateDocumentDetails:(NSMutableDictionary *)DocumentData
{
    
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE localdoc SET tCategoryname = '%@',tSubcategoryname = '%@',tTitle = '%@',tDocUrl = '%@',DateNTime = '%@' WHERE tUserId = '%@' AND tDocumentId = '%@'",
                          
                          [DocumentData objectForKey:@"tCategoryname"],
                          [DocumentData objectForKey:@"tSubcategoryname"],
                          [DocumentData objectForKey:@"tTitle"],
                          [DocumentData objectForKey:@"tDocUrl"],
                          [DocumentData objectForKey:@"DateNTime"],
                        [DocumentData objectForKey:@"tUserId"],
                          [DocumentData objectForKey:@"tDocumentId"]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}



-(NSError *)updatePassword:(NSMutableDictionary *)userData
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE ma_userDetails SET vPassword = '%@' WHERE tUser_iD = '%@'",
                          [userData objectForKey:@"vPassword"],
                          [userData objectForKey:@"tUser_iD"]];
    
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

- (NSError *)updateAllUsersValidTill:(NSString *)date {
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE ma_userDetails SET vValid_Till = '%@'",
                          date];
    NSError *error = [self.dbManager doQuery:strQuery];
return error;
}

-(NSArray *)getUserDetailsForEmailid:(NSString *) emailid{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT vPassword,vValid_Till,tUser_iD FROM ma_userDetails Where vEmail_Id='%@'", emailid ];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}


-(BOOL)validateUser:(NSString *) securityCode
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM User WHERE vSecurityCode = '%@'", securityCode];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    NSLog(@"%@",[data description]);
    if([[[data objectAtIndex:0] objectForKey:@"count(*)"] intValue] == 0)
        return NO;
    else
        return YES;
}

-(BOOL)validateUserEmailId:(NSString *) emailid
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT count(*) FROM ma_userDetails WHERE vEmail_Id = '%@'", emailid];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    if([[[data objectAtIndex:0] objectForKey:@"count(*)"] intValue] == 0)
        return NO;
    else
        return YES;
}

-(NSArray *)getThemeDetails{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM Theme"];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(int)LastinsertedId{
    return  [self.dbManager getlastInsertedId];
}

-(NSArray *)getJournal{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM JournalPages order by iJournalpage_Id desc"];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSError *)addJournal:(NSMutableDictionary *)JournalData
{
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO JournalPages (vSubject_name, vNotes, iThemeId, eStatus) VALUES (\"%@\",\"%@\",\"%d\",0)", [[JournalData objectForKey:@"vSubject_name"] stringByReplacingOccurrencesOfString:@"\"" withString:@""], 
                          [[JournalData objectForKey:@"vNotes"]stringByReplacingOccurrencesOfString:@"\"" withString:@""], 
                          [[JournalData objectForKey:@"iThemeId"] intValue]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;    
}

-(NSError *)updateJournal:(NSMutableDictionary *)JournalData
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE JournalPages SET vSubject_name = \"%@\",vNotes = \"%@\",iThemeId = '%d' WHERE iJournalpage_Id = '%d'",
                          [[JournalData objectForKey:@"vSubject_name"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[JournalData objectForKey:@"vNotes"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[JournalData objectForKey:@"iThemeId"] intValue],
                          [[JournalData objectForKey:@"iJournalpage_Id"] intValue]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

#pragma mark Family Tree methods

-(NSArray *)getFamilyRelationships{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM Relationship"];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;

}

-(NSError *)addTreeData:(NSMutableArray *)aryData forAlbumID:(int)iAlbumID{
    NSString *strQuery = @"";
    NSError *error = nil;
    for(int i = 0 ; i<[aryData count]; i++){
        strQuery = [NSString stringWithFormat:@"INSERT INTO FamilyTree ( iAlbumId, iRelationShip_Id, vRelative_name, vMember_Image, eStatus) VALUES (%d, %d, '%@', '%@', 0)", 
                    iAlbumID,
                    [[[aryData objectAtIndex:i] objectForKey:@"iRelationShip_Id"] intValue],
                    [[aryData objectAtIndex:i] objectForKey:@"vRelative_name"],
                    [[aryData objectAtIndex:i] objectForKey:@"vMember_Image"]];
        error  = [self.dbManager doQuery:strQuery];
    }
    return error;

}


-(NSArray *)getTreeDataForAlbum:(int)albumID{
       NSString *strQuery = [NSString stringWithFormat:@"SELECT r.iLevelPosition,r.iPosition,r.iRelationShip_Id,f.iTree_id,f.vMember_Image,r.vRelation_name,f.vRelative_name FROM FamilyTree f, Relationship r where iAlbumId = %d AND f.iRelationShip_Id = r.iRelationShip_Id", albumID];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSError *)updateTreeDataForAlbum:(int)albumID withData:(NSArray *)aryData{
    NSString *strQuery = [NSString stringWithFormat:@"Delete FROM FamilyTree where iAlbumId = '%d'",albumID];
    NSError *error = [self.dbManager doQuery:strQuery];
    if([aryData count]>0)
    [self addTreeData:[NSMutableArray arrayWithArray:aryData] forAlbumID:albumID];
    return error;
}

#pragma mark Ctreate New Album Metrhods
-(NSError *)createNewAlbum:(NSMutableDictionary *)userData
{
NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO MyAlbums (iUserId, iThemeId, iQuickPixId, iJournalpage_Id,vAlbumName, vBabyImage,vCoverImage,vGiven_name, vLast_name,dBirth_datetime,fWeight,fHeight,vEye_color,vHair_color,vDoctor_name,vBirth_place,vOther_details,vBirth_story,vMajor_headlines,vPopular_music,vPopular_movie,vNational_world_leader,vWeather_details,vOther_notes,dCreated_datetime,eStatus,vOrder_Arranged, vAlbumGUID,iQuickPixTheme) VALUES ('%d','%d',\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%d\")",
                      [[userData objectForKey:@"iUserId"] intValue],
                      [[userData objectForKey:@"iThemeId"]intValue],
                      [userData objectForKey:@"iQuickPixId"],
                      [userData objectForKey:@"iJournalpage_Id"],
                      [[userData objectForKey:@"vAlbumName"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [userData objectForKey:@"vBabyImage"],
                       [userData objectForKey:@"vCoverImage"],
                      [[userData objectForKey:@"vGiven_name"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vLast_name"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [userData objectForKey:@"dBirth_datetime"],
                      [[userData objectForKey:@"fWeight"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"fHeight"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vEye_color"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vHair_color"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vDoctor_name"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vBirth_place"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vOther_details"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vBirth_story"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vMajor_headlines"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vPopular_music"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vPopular_movie"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vNational_world_leader"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vWeather_details"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [[userData objectForKey:@"vOther_notes"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                      [userData objectForKey:@"dCreated_datetime"],
                      [userData objectForKey:@"eStatus"],
                      [userData objectForKey:@"vOrder_Arranged"],
                      [userData objectForKey:@"vAlbumGUID"],
                      [[userData objectForKey:@"iQuickPixTheme"]intValue]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}
//-(NSError *)UpdateQuickPixThemeId:(NSMutableDictionary *)quickPixData{
//    
//    NSString *strQuery = [NSString stringWithFormat:@"UPDATE MyAlbums SET iQuickPixTheme = '%d', WHERE iQuickPixId = '%d'", 
//                          [[quickPixData objectForKey:@"iThemeId"] intValue],
//                          [[quickPixData objectForKey:@"iQuickPixId"] intValue]];
//    NSError *error = [self.dbManager doQuery:strQuery];
//    return error;  
//    
//}

-(NSError *)updateAlbumOrder:(NSString *)strOrder:(int)albumID{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE MyAlbums SET vOrder_Arranged = \"%@\" WHERE iAlbumId = \"%d\"",  strOrder, albumID];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSError *)updateAlbumDetail:(NSMutableDictionary *)DictEditAlbumData:(int)userId
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE MyAlbums SET iThemeId = '%d',iQuickPixId = '%@',iJournalpage_Id = \"%@\",vAlbumName = \"%@\",vBabyImage = \"%@\",vCoverImage = \"%@\",vGiven_name = \"%@\",vLast_name = \"%@\",  dBirth_datetime = \"%@\",fWeight = \"%@\",fHeight = \"%@\",vEye_color = \"%@\",vHair_color = \"%@\",vDoctor_name = \"%@\",vBirth_place = \"%@\",vOther_details = \"%@\",vBirth_story = \"%@\",vMajor_headlines =\"%@\",vPopular_music = \"%@\",vPopular_movie = \"%@\",vNational_world_leader = \"%@\",vWeather_details = \"%@\",vOther_notes = \"%@\",dCreated_datetime = \"%@\",eStatus = \"%@\",vOrder_Arranged = \"%@\" WHERE iAlbumId = \"%d\"",         
                          [[DictEditAlbumData objectForKey:@"iThemeId"]intValue],
                          [DictEditAlbumData objectForKey:@"iQuickPixId"],
                          [DictEditAlbumData objectForKey:@"iJournalpage_Id"],
                          [[DictEditAlbumData objectForKey:@"vAlbumName"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [DictEditAlbumData objectForKey:@"vBabyImage"],
                          [DictEditAlbumData objectForKey:@"vCoverImage"],
                          [[DictEditAlbumData objectForKey:@"vGiven_name"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vLast_name"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [DictEditAlbumData objectForKey:@"dBirth_datetime"],
                          [[DictEditAlbumData objectForKey:@"fWeight"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"fHeight"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vEye_color"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vHair_color"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vDoctor_name"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vBirth_place"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vOther_details"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vBirth_story"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vMajor_headlines"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vPopular_music"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vPopular_movie"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vNational_world_leader"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vWeather_details"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"vOther_notes"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[DictEditAlbumData objectForKey:@"dCreated_datetime"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [DictEditAlbumData objectForKey:@"eStatus"],
                          [[DictEditAlbumData objectForKey:@"vOrder_Arranged"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          userId];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;

}
-(NSArray *)getJournalDetailForJournalId:(int) journalId{
    
    NSString *strQuery = [NSString stringWithFormat:@"SELECT iJournalpage_Id, vSubject_name, vNotes, t.iThemeID, t.vThemeName FROM JournalPages j, Theme t where iJournalpage_Id='%d' AND t.iThemeID = j.iThemeID",journalId];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSError *)DeleteJournalForJournalId:(int)journalid{
    NSString *strQuery = [NSString stringWithFormat:@"DELETE From JournalPages Where iJournalpage_Id = '%d'",journalid];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSError *)DeleteAlbumForAlbumId:(int)albumid{
    NSString *strQuery = [NSString stringWithFormat:@"DELETE From MyAlbums Where iAlbumId = '%d'",albumid];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}

-(NSError *)addQuickPix:(NSMutableDictionary *)quickPixData
{
    NSString *strQuery = [NSString stringWithFormat:@"INSERT INTO QuickPix (iThemeId,vBabyImage, vEvent_name,dEvent_datetime,vNotes,eType,eStatus) VALUES ('%d',\"%@\",\"%@\",\"%@\",\"%@\",\"%d\",0)",
                          [[quickPixData objectForKey:@"iThemeId"] intValue],
                          [quickPixData objectForKey:@"vBabyImage"], 
                          [[quickPixData objectForKey:@"vEvent_name"] stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [quickPixData objectForKey:@"dEvent_datetime"],
                          [[quickPixData objectForKey:@"vNotes"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[quickPixData objectForKey:@"eType"] intValue]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;    
}


-(NSError *)UpdateQuickPix:(NSMutableDictionary *)quickPixData
{
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE QuickPix SET iThemeId = '%d',vBabyImage = '%@',vEvent_name = \"%@\",dEvent_datetime = \"%@\",vNotes = \"%@\", eType = '%d' WHERE iQuickPixId = '%d'", 
                          [[quickPixData objectForKey:@"iThemeId"] intValue],
                          [quickPixData objectForKey:@"vBabyImage"],
                          [[quickPixData objectForKey:@"vEvent_name"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [quickPixData objectForKey:@"dEvent_datetime"],
                          [[quickPixData objectForKey:@"vNotes"]stringByReplacingOccurrencesOfString:@"\"" withString:@""],
                          [[quickPixData objectForKey:@"eType"] intValue],
                          [[quickPixData objectForKey:@"iQuickPixId"] intValue]];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;    
}


-(NSArray *)getQuickPix{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT iQuickPixId, q.iThemeId, vBabyImage,vEvent_name,dEvent_datetime,vNotes,eType,t.iThemeID, t.vThemeName FROM QuickPix q, Theme t where t.iThemeID = q.iThemeID order by iQuickPixId desc"];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSArray *)getQuickPixDetailForQuickPixId:(int) QuickpixId{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT iQuickPixId, q.iThemeId, vBabyImage,vEvent_name,dEvent_datetime,vNotes,eType,t.iThemeID, t.vThemeName FROM QuickPix q, Theme t where iQuickPixId='%d' AND t.iThemeID = q.iThemeID",QuickpixId];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSError *)DeleteQuickPixForQuickpixId:(int)quickpixid{
    NSString *strQuery = [NSString stringWithFormat:@"DELETE From QuickPix Where iQuickPixId = '%d'",quickpixid];
    NSError *error = [self.dbManager doQuery:strQuery];
    return error;
}
-(NSArray *)getArrayMyalbumData
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT iAlbumId, iThemeId, vAlbumName,vBabyImage,dCreated_datetime,vAlbumGUID FROM MyAlbums order by iAlbumId desc"];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}
-(NSArray *)getDataForAlbumID:(int)albumID
{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT * FROM MyAlbums Where iAlbumId = '%d'",albumID];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return data;
}

-(NSString *)getThemeName:(int)themeId{
    NSString *strQuery = [NSString stringWithFormat:@"SELECT vThemeName FROM Theme Where iThemeID = '%d'",themeId];
    NSArray *data = [self.dbManager getRowsForQuery:strQuery];
    return [[data objectAtIndex:0] objectForKey:@"vThemeName"];
}
@end
