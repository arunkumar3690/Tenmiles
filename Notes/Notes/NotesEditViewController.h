//
//  NotesEditViewController.h
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

@interface NotesEditViewController : UIViewController<UITextViewDelegate>
{
    __weak IBOutlet UITextView *notesTextView;
}

@end
