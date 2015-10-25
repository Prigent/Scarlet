//
//  Profile.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Demand, Event, FriendRequest, Interest, Message, Picture;

NS_ASSUME_NONNULL_BEGIN

@interface Profile : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Profile+CoreDataProperties.h"
