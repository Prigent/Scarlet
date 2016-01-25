//
//  ShareAppContext.h
//  OM
//
//  Created by Prigent ROUDAUT on 14/01/2015.
//  Copyright (c) 2015 HighConnexion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class User;
@interface ShareAppContext : NSObject<CLLocationManagerDelegate>

+ (ShareAppContext *)sharedInstance;

@property (nonatomic) BOOL firstStarted;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSOperationQueue* queue;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* userIdentifier;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSDictionary* notificationDic;
@property (strong, nonatomic) NSString* currentMood;
@property (strong, nonatomic) NSDate* currentDate;
@property (nonatomic) double currentRadius;

-(void) updatePlacemark:(void (^)(NSError* error)) onCompletion;
-(void) startLocation;

@property (strong, nonatomic) User* user;

@end
