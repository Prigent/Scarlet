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


@implementation ProfileCell

-(void) configure:(Profile*) profile
{
    Picture* picture = [profile.pictures firstObject];
    [self.mImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:profile.birthdate
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.mTitle.text = [NSString stringWithFormat:@"%@ %@, %ld", profile.firstName,profile.name,age];
    
    
}
@end
