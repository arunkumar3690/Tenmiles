//
//  DropBoxManager.h
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>


@protocol DropBoxServiceHandlers <NSObject>

@optional

-(void)logginCompletion;
-(void)readFileCompletion:(NSArray *)files;

@end

@class DBNote;
@interface DropBoxManager : NSObject

@property (nonatomic, strong)DBAccount *loggedInAccount;

@property (nonatomic, strong)DBFilesystem *fileSystem;

@property (nonatomic, strong)DBNote *selectedFile;

@property (nonatomic, weak) id <DropBoxServiceHandlers> delegate;

+(id)sharedDropboxManager;

-(void)dropboxLoginFromView:(id)viewController;

-(void)handleLoginResponseWithResponseURL:(NSURL *)appRedirectURL;

-(void)dropboxLogout;

-(void)readDropboxFilesFromView:(id)viewController;

-(DBNote *)getDropBoxFile:(DBFileInfo *)fileInfo;

-(BOOL)createNewFileWithText:(NSString *)text;

-(BOOL)deleteFileFromDropBoxServer:(DBFileInfo *)fileInfo;

@end
