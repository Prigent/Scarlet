//
//  ShareAppContext.m
//  OM
//
//  Created by Prigent ROUDAUT on 14/01/2015.
//  Copyright (c) 2015 HighConnexion. All rights reserved.
//

#import "ShareAppContext.h"
#import "User.h"
#import "WSManager.h"

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
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     self.errorLocation = false;
    //[manager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    CLLocation * location = [locations firstObject];
    
    
    if(location)
    {
        BOOL isInBackground = NO;
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        {
            isInBackground = YES;
        }
        if (isInBackground)
        {
            [self sendBackgroundLocationToServer:location];
        }
        else
        {
            NSTimeInterval lNSTimeInterval = [[NSDate date] timeIntervalSince1970];
            if((lNSTimeInterval - mLastBackgroundInterval)>60)
            {
                [[WSManager sharedInstance] geoLocate:location.coordinate.longitude andLat:location.coordinate.latitude];
                [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
                 {
                     if (!(error))
                     {
                         mLastBackgroundInterval = lNSTimeInterval;
                         self.errorLocation = false;
                         self.placemark = [placemarks firstObject];
                     }
                 }];
            }
        }
    }
}


- (void) sendBackgroundLocationToServer: (CLLocation *) location
{

    NSTimeInterval lNSTimeInterval = [[NSDate date] timeIntervalSince1970];
    if((lNSTimeInterval - mLastBackgroundInterval)>60)
    {
        if(_lastLatSend != location.coordinate.latitude  && _latLongSend != location.coordinate.longitude)
        {
            mLastBackgroundInterval = lNSTimeInterval;
            _lastLatSend = location.coordinate.latitude;
            _latLongSend = location.coordinate.longitude;
            [[WSManager sharedInstance] geoLocate:location.coordinate.longitude andLat:location.coordinate.latitude];
        }
    }



}



- (void)locationManager:(CLLocationManager *)manager  didFailWithError:(NSError *)error
{
    NSLog(@"locationManager %@ %ld", error.localizedDescription, error.code);
    if( error.code != 0)
    {
        if(self.errorLocation == false)
        {
            UIAlertView * lUIAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString2(@"localisation_error_title", nil) delegate:self cancelButtonTitle:NSLocalizedString2(@"localisation_error_cancel", nil) otherButtonTitles:NSLocalizedString2(@"localisation_error_ok", nil), nil];
            [lUIAlertView show];
        }
        self.errorLocation = true;
        
    }

}


-(void) updatePlacemark
{
    if(self.errorLocation==true && [ShareAppContext sharedInstance].user != nil)
    {
        CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake([[ShareAppContext sharedInstance].user.lat doubleValue], [[ShareAppContext sharedInstance].user.longi doubleValue]);
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:location2D.latitude longitude:location2D.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!error)
             {
                 CLPlacemark * lCLPlacemark = [placemarks firstObject];
                 _placemark = lCLPlacemark;
             }
         }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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


+ (NSString*)customLocalize:(NSString *) key
{
    NSString * returnValue = nil;
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *languageCode = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSDictionary * lang = [[NSUserDefaults standardUserDefaults] valueForKey:languageCode];
    if(lang != nil)
    {
        returnValue = [lang valueForKey:key];
    }
    else
    {
        returnValue = NSLocalizedString(key, nil);
    }
    
    if([returnValue length]>0)
    {
        return returnValue;
    }
    else
    {
        return key;
    }
    
};

@end
