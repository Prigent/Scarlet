//
//  ProfileViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "KIImagePager.h"

@class Profile;
@interface ProfileViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet KIImagePager *mImagePager;
@property (strong, nonatomic) Profile* mProfile;
@end
