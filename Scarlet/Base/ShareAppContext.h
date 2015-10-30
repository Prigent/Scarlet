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

@interface ShareAppContext : NSObject

+ (ShareAppContext *)sharedInstance;

@property (nonatomic) BOOL firstStarted;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSOperationQueue* queue;
@property (strong, nonatomic) NSString* userIdentifier;
@property (strong, nonatomic) CLLocationManager* locationManager;

+ (BOOL)isConnected;
+ (BOOL)isOnline;
@end
