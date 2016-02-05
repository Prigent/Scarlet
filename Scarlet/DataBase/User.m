//
//  User.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "User.h"
#import "FriendRequest.h"
#import "Picture.h"
@implementation User

// Insert code here to add functionality to your managed object subclass
- (NSDictionary*) getDictionary
{
    NSMutableDictionary * lDic = [NSMutableDictionary dictionary];
    [lDic setObject:self.occupation forKey:@"occupation"];
    [lDic setObject:self.about forKey:@"about"];
    
    NSMutableArray* lPictureList = [NSMutableArray array];
    for(Picture* lPicture in self.pictures)
    {
        [lPictureList addObject:lPicture.filename];
    }
    
    [lDic setObject:lPictureList forKey:@"picture"];
    
    
    [lDic setObject:self.ageMax forKey:@"age_max"];
    [lDic setObject:self.ageMin forKey:@"age_min"];
    [lDic setObject:self.lookingFor forKey:@"lookingfor"];

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] != nil)
    {
        [lDic setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] forKey:@"apple_push_token"];
    }
    NSLog(@"lDic USER %@",lDic);

    return lDic;
}

@end
