//
//  ProfileCell.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 03/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendRequest;
@interface ProfileCell : UITableViewCell

@property (retain, nonatomic) FriendRequest* mFriendRequest;

@property (weak, nonatomic) IBOutlet UIImageView *mImage;
@property (weak, nonatomic) IBOutlet UILabel *mTitle;
@property (weak, nonatomic) IBOutlet UIButton *mStatusProfile;
-(void) configure:(id) profile;
@end
