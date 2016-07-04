//
//  Profile.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 20/06/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Demand, Event, FacebookProfile, FriendRequest, Interest, Message, Picture, User;

NS_ASSUME_NONNULL_BEGIN

@interface Profile : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Profile+CoreDataProperties.h"
