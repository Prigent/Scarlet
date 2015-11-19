//
//  FacebookProfile+CoreDataProperties.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 18/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FacebookProfile.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacebookProfile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *picture;
@property (nullable, nonatomic, retain) NSSet<Profile *> *profiles;

@end

@interface FacebookProfile (CoreDataGeneratedAccessors)

- (void)addProfilesObject:(Profile *)value;
- (void)removeProfilesObject:(Profile *)value;
- (void)addProfiles:(NSSet<Profile *> *)values;
- (void)removeProfiles:(NSSet<Profile *> *)values;

@end

NS_ASSUME_NONNULL_END
