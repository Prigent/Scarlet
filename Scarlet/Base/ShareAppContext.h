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
@interface ShareAppContext : NSObject<CLLocationManagerDelegate, UIAlertViewDelegate>
{
    NSTimeInterval mLastBackgroundInterval;
}
+ (ShareAppContext *)sharedInstance;

@property (nonatomic) BOOL firstStarted;
@property (nonatomic) double lastLatSend;
@property (nonatomic) double latLongSend;



@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSOperationQueue* queue;
@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* userIdentifier;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSDictionary* notificationDic;
@property (strong, nonatomic) NSDate* currentDate;
@property (nonatomic) BOOL errorLocation;
@property (nonatomic) double currentRadius;
+ (NSString*)customLocalize:(NSString *) key;
-(void) updatePlacemark;
-(void) startLocation;

@property (strong, nonatomic) User* user;

@end
