//
//  FriendRequest+CoreDataProperties.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FriendRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) Profile *profile;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
