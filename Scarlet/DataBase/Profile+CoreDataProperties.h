//
//  Profile+CoreDataProperties.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Profile.h"

NS_ASSUME_NONNULL_BEGIN

@interface Profile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *about;
@property (nullable, nonatomic, retain) NSDate *birthdate;
@property (nullable, nonatomic, retain) NSString *fbIdentifier;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *occupation;
@property (nullable, nonatomic, retain) NSSet<Event *> *eventLeaders;
@property (nullable, nonatomic, retain) NSSet<Event *> *eventPartners;
@property (nullable, nonatomic, retain) NSSet<FriendRequest *> *friendRequests;
@property (nullable, nonatomic, retain) NSSet<Profile *> *friends;
@property (nullable, nonatomic, retain) NSSet<Profile *> *friendsOf;
@property (nullable, nonatomic, retain) NSSet<Interest *> *interests;
@property (nullable, nonatomic, retain) NSSet<Demand *> *leaderDemands;
@property (nullable, nonatomic, retain) NSSet<Message *> *messages;
@property (nullable, nonatomic, retain) NSSet<Demand *> *partnerDemands;
@property (nullable, nonatomic, retain) NSOrderedSet<Picture *> *pictures;

@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addEventLeadersObject:(Event *)value;
- (void)removeEventLeadersObject:(Event *)value;
- (void)addEventLeaders:(NSSet<Event *> *)values;
- (void)removeEventLeaders:(NSSet<Event *> *)values;

- (void)addEventPartnersObject:(Event *)value;
- (void)removeEventPartnersObject:(Event *)value;
- (void)addEventPartners:(NSSet<Event *> *)values;
- (void)removeEventPartners:(NSSet<Event *> *)values;

- (void)addFriendRequestsObject:(FriendRequest *)value;
- (void)removeFriendRequestsObject:(FriendRequest *)value;
- (void)addFriendRequests:(NSSet<FriendRequest *> *)values;
- (void)removeFriendRequests:(NSSet<FriendRequest *> *)values;

- (void)addFriendsObject:(Profile *)value;
- (void)removeFriendsObject:(Profile *)value;
- (void)addFriends:(NSSet<Profile *> *)values;
- (void)removeFriends:(NSSet<Profile *> *)values;

- (void)addFriendsOfObject:(Profile *)value;
- (void)removeFriendsOfObject:(Profile *)value;
- (void)addFriendsOf:(NSSet<Profile *> *)values;
- (void)removeFriendsOf:(NSSet<Profile *> *)values;

- (void)addInterestsObject:(Interest *)value;
- (void)removeInterestsObject:(Interest *)value;
- (void)addInterests:(NSSet<Interest *> *)values;
- (void)removeInterests:(NSSet<Interest *> *)values;

- (void)addLeaderDemandsObject:(Demand *)value;
- (void)removeLeaderDemandsObject:(Demand *)value;
- (void)addLeaderDemands:(NSSet<Demand *> *)values;
- (void)removeLeaderDemands:(NSSet<Demand *> *)values;

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet<Message *> *)values;
- (void)removeMessages:(NSSet<Message *> *)values;

- (void)addPartnerDemandsObject:(Demand *)value;
- (void)removePartnerDemandsObject:(Demand *)value;
- (void)addPartnerDemands:(NSSet<Demand *> *)values;
- (void)removePartnerDemands:(NSSet<Demand *> *)values;

- (void)insertObject:(Picture *)value inPicturesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPicturesAtIndex:(NSUInteger)idx;
- (void)insertPictures:(NSArray<Picture *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePicturesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPicturesAtIndex:(NSUInteger)idx withObject:(Picture *)value;
- (void)replacePicturesAtIndexes:(NSIndexSet *)indexes withPictures:(NSArray<Picture *> *)values;
- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSOrderedSet<Picture *> *)values;
- (void)removePictures:(NSOrderedSet<Picture *> *)values;

@end

NS_ASSUME_NONNULL_END
