//
//  Demand+CoreDataProperties.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Demand.h"

NS_ASSUME_NONNULL_BEGIN

@interface Demand (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSDate *dateAnswer;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) Event *event;
@property (nullable, nonatomic, retain) Profile *leader;
@property (nullable, nonatomic, retain) NSSet<Profile *> *partners;

@end

@interface Demand (CoreDataGeneratedAccessors)

- (void)addPartnersObject:(Profile *)value;
- (void)removePartnersObject:(Profile *)value;
- (void)addPartners:(NSSet<Profile *> *)values;
- (void)removePartners:(NSSet<Profile *> *)values;

@end

NS_ASSUME_NONNULL_END
