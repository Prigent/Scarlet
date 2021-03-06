

#import "ReverseGeocoding.h"
#import <AddressBook/AddressBook.h>


@implementation ReverseGeocoding


@synthesize mGeocoder;
@synthesize mDelegate;



#pragma mark -
#pragma mark Object Life Cycle Methods



- (id) initWithDelegate:(NSObject<ReverseGeocodingDelegate>*)_Delegate
{
	self = [super init];
	if (self)
	{
		mGeocoder = [[CLGeocoder alloc] init];
		self.mDelegate = _Delegate;
	}
	return self;
}


#pragma mark -
#pragma mark Data Management Methods



- (void)launchReverseGeocodingForLocation:(CLLocationCoordinate2D)_Location
{
    [mGeocoder cancelGeocode];
    
    CLLocation* loc = [[CLLocation alloc] initWithLatitude:_Location.latitude longitude:_Location.longitude];
    
    [mGeocoder reverseGeocodeLocation:loc completionHandler:^(NSArray* _Placemarks, NSError* _Error)
     {
         if (_Error)
         {
             [mDelegate reverseGeocoder:mGeocoder didFailWithError:_Error];
         }
         else
         {
             [mDelegate reverseGeocoder:mGeocoder didFindPlacemark:_Placemarks];
         }
     }];
}


// Dictionary with keys contained ABPerson/Addresses keys
- (void)launchFowardGeocoderWithDictionary:(NSDictionary*)_Dictionary
{    
    [mGeocoder geocodeAddressDictionary:_Dictionary completionHandler:^(NSArray* _Placemarks, NSError* _Error)
     {
         if (_Error)
         {
             [mDelegate fowardGeocoder:mGeocoder didFailWithError:_Error];
         }
         else
         {
             [mDelegate fowardGeocoder:mGeocoder didFindPlacemark:_Placemarks];
         }
     }];
}


- (void)cancelCurrentReverseGeocoding
{
    [mGeocoder cancelGeocode];
}



@end
