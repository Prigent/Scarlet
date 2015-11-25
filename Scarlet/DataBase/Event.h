//
//  Event.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Chat, Demand, Profile;

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(NSInteger) getMyStatus;
-(NSInteger) getWaitingDemand;


@end

NS_ASSUME_NONNULL_END

#import "Event+CoreDataProperties.h"
