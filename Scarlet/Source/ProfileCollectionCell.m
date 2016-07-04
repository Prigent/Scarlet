//
//  ProfileCollectionCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 03/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ProfileCollectionCell.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import "Picture.h"
#import "FriendRequest.h"
#import "FacebookProfile.h"

@implementation ProfileCollectionCell
-(void) configure:(id) data
{
    self.mData = data;
    self.mImage.image = nil;
    
    if([data isKindOfClass: [FacebookProfile class]])
    {
        FacebookProfile * facebookProfile = (FacebookProfile*)data;
        [self.mImage setImageWithURL:[NSURL URLWithString:facebookProfile.picture]];
        self.mTitle.text = [NSString stringWithFormat:@"%@", facebookProfile.name];
        return;
    }
    
    Profile * profile;
    if([data isKindOfClass: [Profile class]])
    {
        profile = (Profile*)data;
    }
    else if([data isKindOfClass: [FriendRequest class]])
    {
        profile = ((FriendRequest*)data).profile;
    }
    Picture* picture = [profile.pictures firstObject];
    [self.mImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    

    
    NSString *firstLetter = [profile.name substringToIndex:1];
    firstLetter = [firstLetter uppercaseString];
    
    self.mTitle.text = [NSString stringWithFormat:@"%@ %@.", profile.firstName,firstLetter];
}
- (IBAction)selectCell:(id)sender {
    if(self.mData != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"profilelistselected" object:self.mData];
    }
}
- (IBAction)selectEvent:(id)sender {
    if(self.mEvent != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"eventselected" object:self.mEvent];
    }
}
- (IBAction)selectProfile:(id)sender {
    if(self.mData != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectProfile" object:self.mData];
    }
}



@end
