//
//  DropBoxManager.m
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import "DropBoxManager.h"
#import "DBNote.h"

@implementation DropBoxManager
@synthesize delegate;

#pragma  mark - SingleTon Pattern

- (id)init
{
    static DropBoxManager *sharedManager = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken
                  , ^{
                      sharedManager = [super init];
                      
                      DBAccountManager *accountManager = [[DBAccountManager alloc] initWithAppKey:@"x2ticp4vwlrwff9" secret:@"gnj5qcxpew7peyr"];
                      [DBAccountManager setSharedManager:accountManager];
                  });
    
    return sharedManager;
    
}

+ (id)sharedDropboxManager
{
    return [self new];
}


#pragma mark - Dropbox LogIn & LogOut methods

- (void)dropboxLoginFromView:(id)viewController
{
    delegate = viewController;
    [[DBAccountManager sharedManager] linkFromController:viewController];
}

- (void)handleLoginResponseWithResponseURL:(NSURL *)appRedirectURL
{
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:appRedirectURL];
    if (account)
    {
        self.loggedInAccount = account;
        
        if (delegate && [delegate respondsToSelector:@selector(logginCompletion)])
        {
            [delegate logginCompletion];
        }
    }
}

- (void)dropboxLogout
{
    [_fileSystem shutDown];
    [self.loggedInAccount unlink];
    self.loggedInAccount = nil;
}


#pragma mark - Dropbox File manipulation methods

- (DBNote *)getDropBoxFile:(DBFileInfo *)fileInfo
{
    DBNote *noteFile = [[DBNote alloc] init];
    DBFile *file = [_fileSystem openFile:fileInfo.path error:nil];
    noteFile.fileInfo = fileInfo;
    noteFile.file = file;
    noteFile.fileName = [fileInfo.path name];
    noteFile.fileText = [file readString:nil];
    
    return noteFile;
}

- (void)readDropboxFilesFromView:(id)viewController
{
    delegate = viewController;
    [_fileSystem shutDown];
    _fileSystem = [[DBFilesystem alloc] initWithAccount:self.loggedInAccount];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^() {
        NSArray *dropBoxFiles = [_fileSystem listFolder:[DBPath root] error:nil];
        dispatch_async(dispatch_get_main_queue(), ^() {
            if (delegate && [delegate respondsToSelector:@selector(readFileCompletion:)])
            {
                [delegate readFileCompletion:dropBoxFiles];
            }
        });
    });
}

- (BOOL)createNewFileWithText:(NSString *)text
{
    NSString *fileName = (text.length >= 15) ? [text substringToIndex:15] : text;
    
    NSArray *words = [fileName componentsSeparatedByString:@" "];
    
    if (words.count)
        fileName = [[words firstObject]stringByAppendingString:[words lastObject]];
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];

    DBPath *path = [[DBPath root] childPath:[NSString stringWithFormat:@"%@.txt", fileName]];
    DBFile *newFile = [_fileSystem createFile:path error:nil];
    
    [newFile writeString:text error:nil];
    
    return [newFile update:nil];
}

- (BOOL)deleteFileFromDropBoxServer:(DBFileInfo *)fileInfo
{
   return [_fileSystem deletePath:fileInfo.path error:nil];
}

@end
