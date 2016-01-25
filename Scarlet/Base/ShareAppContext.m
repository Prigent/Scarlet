//
//  ShareAppContext.m
//  OM
//
//  Created by Prigent ROUDAUT on 14/01/2015.
//  Copyright (c) 2015 HighConnexion. All rights reserved.
//

#import "ShareAppContext.h"
#import "User.h"

@implementation ShareAppContext

@synthesize accessToken=_accessToken, firstStarted=_firstStarted, userIdentifier=_userIdentifier;


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}


-(void) startLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //[manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:[locations objectAtIndex:0] completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             self.placemark = [placemarks objectAtIndex:0];
         }
     }];
}




-(void) updatePlacemark:(void (^)(NSError* error)) onCompletion
{
    if(_placemark==nil)
    {
        CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake([[ShareAppContext sharedInstance].user.lat doubleValue], [[ShareAppContext sharedInstance].user.longi doubleValue]);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!error)
             {
                 CLPlacemark * lCLPlacemark = [placemarks objectAtIndex:0];
                 _placemark = lCLPlacemark;
             }
             onCompletion(nil);
         }];
    }
    else
    {
        onCompletion(nil);
    }
}



+ (ShareAppContext *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}




- (void)setUserIdentifier:(NSString* )userIdentifier {
    _userIdentifier = userIdentifier;
    [[NSUserDefaults standardUserDefaults] setValue:_userIdentifier forKey:@"userIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)userIdentifier {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"userIdentifier"];
}

- (void)setAccessToken:(NSString* )accessToken {
    _accessToken = accessToken;
    [[NSUserDefaults standardUserDefaults] setValue:_accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)accessToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"accessToken"];
}

- (void)setFirstStarted:(BOOL )firstStarted {
    _firstStarted = firstStarted;
    [[NSUserDefaults standardUserDefaults] setBool:_firstStarted forKey:@"firstStarted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)firstStarted {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStarted"];
}

@end
