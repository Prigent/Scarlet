//
//  ProfileListCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ProfileListCell.h"
#import "Profile.h"
#import "Picture.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configure:(NSArray*) listProfile
{
    int i=0;
    for(UIImageView * imageView in _mProfileListImage)
    {
        imageView.image = nil;
    }
    for(UILabel * labelView in _mProfileListLabel)
    {
        labelView.text = nil;
    }
    
    
    for(Profile * profile in listProfile)
    {
        if( [_mProfileListImage count] > i)
        {
            UIImageView * lProfileImage = [_mProfileListImage objectAtIndex:i];
            UILabel* lProfileLabel = [_mProfileListLabel objectAtIndex:i];
            
            Picture* picture = [profile.pictures firstObject];
            [lProfileImage setImageWithURL:[NSURL URLWithString:picture.filename]];
            
            lProfileLabel.text = profile.firstName;
        }
        i++;
    }
}

@end
