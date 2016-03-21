//
//  ViewController.m
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import "LoginViewController.h"
#import "NotesViewController.h"
#import "DropBoxManager.h"
#import "AppConstants.h"


@interface LoginViewController ()<DropBoxServiceHandlers>
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - IBAction Methods

- (IBAction)signinPressed:(id)sender
{
    [[DropBoxManager sharedDropboxManager]dropboxLoginFromView:self];
}

#pragma mark - DropBoxManager Delegate Method

-(void)logginCompletion
{
    self.navigationController.navigationBarHidden = NO;
    NotesViewController *m_NotesViewController = GET_CONTROLLER(@"NotesViewStoryboardID") ;
    [self.navigationController pushViewController:m_NotesViewController animated:YES];
}

@end
