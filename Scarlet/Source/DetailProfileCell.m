//
//  DetailProfileCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "DetailProfileCell.h"
#import "Profile.h"


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
    self.mNameLabel.text = [NSString stringWithFormat:@"%@ %@", profile.name, profile.firstName];
    
    self.mOccupationLabel.text = profile.occupation;
    self.mAboutLabel.text = profile.about;
    
    self.mCountFriendLabel.text = [NSString stringWithFormat:@"%lu",[profile.friends count]];
}

@end
