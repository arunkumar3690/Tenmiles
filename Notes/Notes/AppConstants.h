//
//  AppConstants.h
//  Notes
//
//  Created by Arunkumar on 21/03/16.
//  Copyright © 2016 Tenmiles. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"

#ifndef AppConstants_h
#define AppConstants_h

#define APPDELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define SHOW_ALERT(title, msg)      [[[UIAlertView alloc] initWithTitle:title message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil] show]

#define GET_CONTROLLER(name)        [self.storyboard instantiateViewControllerWithIdentifier:name]

#endif
