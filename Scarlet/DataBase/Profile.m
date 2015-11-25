//
//  Profile.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "Profile.h"
#import "Demand.h"
#import "Event.h"
#import "FriendRequest.h"
#import "Interest.h"
#import "Message.h"
#import "Picture.h"

@implementation Profile

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

@end
