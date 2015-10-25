//
//  User+CoreDataProperties.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *ageMax;
@property (nullable, nonatomic, retain) NSNumber *ageMin;
@property (nullable, nonatomic, retain) NSNumber *lookingFor;
@property (nullable, nonatomic, retain) NSSet<FriendRequest *> *friendRequest;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFriendRequestObject:(FriendRequest *)value;
- (void)removeFriendRequestObject:(FriendRequest *)value;
- (void)addFriendRequest:(NSSet<FriendRequest *> *)values;
- (void)removeFriendRequest:(NSSet<FriendRequest *> *)values;

@end

NS_ASSUME_NONNULL_END
