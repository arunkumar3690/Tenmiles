//
//  NotesViewController.m
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import "NotesViewController.h"
#import "NotesEditViewController.h"
#import "DropBoxManager.h"
#import "DBNote.h"
#import "AppConstants.h"

@interface NotesViewController ()<DropBoxServiceHandlers>
{
    NSMutableArray *dropBoxFiles;
    UIAlertView *confirmationAlert;
}
@end

@implementation NotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Dropbox";
    
    UIBarButtonItem *addNotesButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Notes"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(addNotesButtonPressed:)];
    self.navigationItem.rightBarButtonItem = addNotesButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(logoutButtonPressed:)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    dropBoxFiles = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [notesTableView reloadData];
    [self loadFiles];    // Load all the saved files
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dropBoxFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *notesCellIdentifier = @"NotesCell";
    UITableViewCell *notesCell = [tableView dequeueReusableCellWithIdentifier:notesCellIdentifier];
    
    DBNote *note = [[DropBoxManager sharedDropboxManager] getDropBoxFile:[dropBoxFiles objectAtIndex:[indexPath row]]];
    [[notesCell textLabel] setText:[note.fileName stringByReplacingOccurrencesOfString:@".txt" withString:@""]];
    [[notesCell detailTextLabel] setText:note.fileText];
    
    return notesCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBNote *selectedNote = [[DropBoxManager sharedDropboxManager] getDropBoxFile:[dropBoxFiles objectAtIndex:[indexPath row]]];
    [[DropBoxManager sharedDropboxManager] setSelectedFile:selectedNote];
    [self pushToNotesEditView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    confirmationAlert = [[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Are you sure wa to delete this file" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [confirmationAlert setTag:indexPath.row];
    
    [confirmationAlert show];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if ([[DropBoxManager sharedDropboxManager] deleteFileFromDropBoxServer:[dropBoxFiles objectAtIndex:alertView.tag]])
            [dropBoxFiles removeObjectAtIndex:alertView.tag];
        else
            SHOW_ALERT(@"Warning", @"Unable To delete the file Try again later");
    }
    [notesTableView reloadData];
}


#pragma mark - IBAction Methods

- (IBAction)addNotesButtonPressed:(id)sender
{
    [[DropBoxManager sharedDropboxManager] setSelectedFile:nil];
    [self pushToNotesEditView];
}

- (IBAction)logoutButtonPressed:(id)sender
{
    [[DropBoxManager sharedDropboxManager] dropboxLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Navigations

- (void)pushToNotesEditView
{
    NotesEditViewController *m_NotesEditViewController = GET_CONTROLLER(@"NotesEditViewStoryboardID");
    [self.navigationController pushViewController:m_NotesEditViewController animated:YES];
}


#pragma  mark - DropBoxFileLoadMethods

- (void)loadFiles
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DropBoxManager sharedDropboxManager] readDropboxFilesFromView:self];
}


#pragma mark - DropBoxManager Delegate Method

- (void)readFileCompletion:(NSArray *)files
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (dropBoxFiles)
        [dropBoxFiles removeAllObjects];
        
    [dropBoxFiles addObjectsFromArray:files];
    
    if (!files.count)
        SHOW_ALERT(@"Warning", @"No Files Available In your Dropox account");
    
    [notesTableView reloadData];
}

@end
