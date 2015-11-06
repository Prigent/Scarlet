//
//  ProfileListViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 03/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListViewController.h"
@class Profile;
@interface ProfileListViewController : AutoListViewController<UISearchBarDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchField;
@property (strong, nonatomic) Profile* mProfileToAdd;
@end
