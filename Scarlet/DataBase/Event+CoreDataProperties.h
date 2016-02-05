//
//  Event+CoreDataProperties.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *mood;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSNumber *sort;
@property (nullable, nonatomic, retain) Address *address;
@property (nullable, nonatomic, retain) Chat *chat;
@property (nullable, nonatomic, retain) NSSet<Demand *> *demands;
@property (nullable, nonatomic, retain) Profile *leader;
@property (nullable, nonatomic, retain) NSSet<Profile *> *partners;
@property (nullable, nonatomic, retain) NSNumber *mystatus;
@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *distanceCustom;
@property (nullable, nonatomic, retain) NSNumber *isMine;
@property (nullable, nonatomic, retain) NSNumber *index;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addDemandsObject:(Demand *)value;
- (void)removeDemandsObject:(Demand *)value;
- (void)addDemands:(NSSet<Demand *> *)values;
- (void)removeDemands:(NSSet<Demand *> *)values;

- (void)addPartnersObject:(Profile *)value;
- (void)removePartnersObject:(Profile *)value;
- (void)addPartners:(NSSet<Profile *> *)values;
- (void)removePartners:(NSSet<Profile *> *)values;

@end

NS_ASSUME_NONNULL_END
