//
//  ShareAppContext.m
//  OM
//
//  Created by Prigent ROUDAUT on 14/01/2015.
//  Copyright (c) 2015 HighConnexion. All rights reserved.
//

#import "ShareAppContext.h"

@implementation ShareAppContext

@synthesize accessToken=_accessToken, firstStarted=_firstStarted, userIdentifier=_userIdentifier;


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.queue = [[NSOperationQueue alloc] init];
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:[locations objectAtIndex:0] completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             self.placemark = [placemarks objectAtIndex:0];
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
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



+ (BOOL)isConnected
{
    bool connected = ([[NSUserDefaults standardUserDefaults] valueForKey:@"user"]!= nil);
    return connected;
}

+ (BOOL)isOnline
{
    NSDictionary * lUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    NSString * lDateString = [lUser valueForKey:@"end_date_om_tv_online"];
    NSDateFormatter * lDateFormater =  [[NSDateFormatter alloc] init];
    [lDateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *lDateAbonnement = [lDateFormater dateFromString:lDateString];

    bool online = ([lDateAbonnement compare:[NSDate date]] == NSOrderedDescending);
    return online;
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
