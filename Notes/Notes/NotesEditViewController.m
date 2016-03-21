//
//  NotesEditViewController.m
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import "NotesEditViewController.h"
#import "DropBoxManager.h"
#import "DBNote.h"
#import "AppConstants.h"

@interface NotesEditViewController ()
{
    DBNote *selectedNote;
}

@end

@implementation NotesEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    selectedNote = [[DropBoxManager sharedDropboxManager]selectedFile];
    self.navigationItem.title = (selectedNote)? [[selectedNote fileName]  stringByDeletingPathExtension] : @"Untitled";
    notesTextView.text = (selectedNote)? [selectedNote fileText] : @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - IBAction Methods

- (IBAction)backButtonPressed:(id)sender
{
    if (selectedNote)
    {
        [[selectedNote file] update:nil];
        SHOW_ALERT(@"", @"Notes Updated Successfully");
    }
    else
    {
        NSString *notesContent = notesTextView.text;
        notesContent = [notesContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([notesContent length] > 0)
        {
            ([[DropBoxManager sharedDropboxManager] createNewFileWithText:notesContent]) ? SHOW_ALERT(@"", @"Notes Updated Successfully") : SHOW_ALERT(@"Error", @"Unable To create Notes");
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - textView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (selectedNote)
        [[selectedNote file] writeString:notesTextView.text error:nil];
}

@end
