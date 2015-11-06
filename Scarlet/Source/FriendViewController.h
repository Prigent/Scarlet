//
//  FriendViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "BaseViewController.h"
@class Profile;
@class User;
@interface FriendViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,FBSDKAppInviteDialogDelegate>


@property (strong, nonatomic) User* mUser;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIButton *mButtonBottom;
@property (strong, nonatomic) id mDataToRespond;
@end
