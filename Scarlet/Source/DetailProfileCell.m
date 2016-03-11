//
//  DetailProfileCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "DetailProfileCell.h"
#import "Profile.h"
#import "ShareAppContext.h"
#import "User.h"

@implementation DetailProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configure:(Profile*) profile
{
    if(profile.identifier == [ShareAppContext sharedInstance].user.identifier)
    {
        _mCountFriendLabel.hidden = true;
        _mEdit.hidden =false;
        _mIconMutual.hidden = true;
        _mLeftAbout.constant = 8;
    }
    else
    {
        _mLeftAbout.active = false;
        
        _mCountFriendLabel.hidden = [profile.mutualFriends count]==0;
        _mEdit.hidden =true;
         _mIconMutual.hidden = [profile.mutualFriends count]==0;
    }
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:profile.birthdate
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.mNameLabel.text = [NSString stringWithFormat:@"%@, %ld", profile.firstName,(long)age];
    
    self.mOccupationLabel.text = profile.occupation;
    self.mAboutLabel.text = profile.about;
    if([profile.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        self.mAboutLabel.numberOfLines =1;
    }
    else
    {
        self.mAboutLabel.numberOfLines =0;
    }
    
    
    
    self.mCountFriendLabel.text = [NSString stringWithFormat:@"%lu",[profile.mutualFriends count]];
}

@end
