//
//  Profile.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 20/06/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import "Profile.h"
#import "Demand.h"
#import "Event.h"
#import "FacebookProfile.h"
#import "FriendRequest.h"
#import "Interest.h"
#import "Message.h"
#import "Picture.h"
#import "User.h"

@implementation Profile

// Insert code here to add functionality to your managed object subclass

- (void)addFriendsObject:(Profile *)value  {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.friends];
    [tempSet addObject:value];
    self.friends = tempSet;
}

- (void)removeFriendsObject:(Profile *)value  {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.friends];
    [tempSet removeObject:value];
    self.friends = tempSet;
}


- (void)removeFriends:(NSOrderedSet<Profile *> *)values
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.friends];
    for(id obj in values)
    {
        [tempSet removeObject:obj];
    }
    self.friends = tempSet;
}

- (void)addPicturesObject:(Picture *)value {
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.pictures];
    [tempSet addObject:value];
    self.pictures = tempSet;
}

- (void)insertObject:(Picture *)value inPicturesAtIndex:(NSUInteger)idx
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.pictures];
    [tempSet insertObject:value atIndex:idx];
    self.pictures = tempSet;
}

- (void)removeObjectFromPicturesAtIndex:(NSUInteger)idx
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.pictures];
    [tempSet removeObjectAtIndex:idx];
    self.pictures = tempSet;
}

- (void)removePictures:(NSOrderedSet<Picture *> *)values
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.pictures];
    for(id obj in values)
    {
        [tempSet removeObject:obj];
    }
    
    
    
    self.pictures = tempSet;
}

@end
