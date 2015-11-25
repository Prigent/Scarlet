//
//  ProfileCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 03/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ProfileCell.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import "Picture.h"
#import "ShareAppContext.h"
#import "User.h"
#import "FriendRequest.h"


@implementation ProfileCell

-(void) configure:(Profile*) profile
{
    Picture* picture = [profile.pictures firstObject];
    [self.mImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    /*
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:profile.birthdate
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.mTitle.text = [NSString stringWithFormat:@"%@ %@, %ld", profile.firstName,profile.name,(long)age];
     
     */

    NSString *firstLetter = [profile.name substringToIndex:1];
    firstLetter = [firstLetter uppercaseString];
    
    self.mTitle.text = [NSString stringWithFormat:@"%@ %@.", profile.firstName,firstLetter];
    
    
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"identifier  == %@",profile.identifier];

    NSArray * friend = [[[ShareAppContext sharedInstance].user.friends allObjects] filteredArrayUsingPredicate:bPredicate];
    

    FriendRequest* friendRequest = [profile.friendRequests anyObject];
    self.mFriendRequest = friendRequest;
    if( [friend count]> 0)
    {
        //[self.mStatusProfile setTitle:@"remove from friends" forState:UIControlStateNormal];
        
        self.mStatusProfile.alpha = 0;
        self.mStatusProfile.tag = 3;
    }
    else if (friendRequest)
    {
        if([friendRequest.type intValue] == 0)
        {
            //[self.mStatusProfile setTitle:@"waiting for response" forState:UIControlStateNormal];
            self.mStatusProfile.alpha = 0.2;
            self.mStatusProfile.tag = 2;
        }
        else
        {
           // [self.mStatusProfile setTitle:@"respond to friend request" forState:UIControlStateNormal];
            
            self.mStatusProfile.alpha = 1;
            self.mStatusProfile.tag = 3;
        }
    }
    else
    {
        //[self.mStatusProfile setTitle:@"add to friends" forState:UIControlStateNormal];
        
        self.mStatusProfile.alpha = 1;
        self.mStatusProfile.tag = 1;
    }
}


- (IBAction)acceptInvitation:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"acceptInvitation" object:self.mFriendRequest];
}

- (IBAction)declineInvitation:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"declineInvitation" object:self.mFriendRequest];
}





@end
