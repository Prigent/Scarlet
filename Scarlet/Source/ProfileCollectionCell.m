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

@implementation ProfileCollectionCell
-(void) configure:(id) data  type:(int) type
{
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
    
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:profile.birthdate
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.mTitle.text = [NSString stringWithFormat:@"%@ %@, %ld", profile.firstName,profile.name,age];
    self.mData = data;
    self.mType = type;
}
- (IBAction)selectCell:(id)sender {
    switch (self.mType) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newInviteRequest" object:self.mData];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"yourFriend" object:self.mData];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"friendSuggestion" object:self.mData];
            break;
        default:
            break;
    }
}
@end
