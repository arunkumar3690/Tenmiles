//
//  NDropBoxNote.h
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropBoxManager.h"

@interface DBNote : NSObject

@property (nonatomic, strong) DBFileInfo *fileInfo;
@property (nonatomic, strong) DBFile *file;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileText;

@end
