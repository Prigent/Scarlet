
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ReverseGeocodingDelegate.h"


@interface ReverseGeocoding : NSObject
{
}


@property (retain, nonatomic) CLGeocoder* mGeocoder;
@property (retain, nonatomic) NSObject<ReverseGeocodingDelegate>* mDelegate;


- (id) initWithDelegate:(NSObject<ReverseGeocodingDelegate>*)_Delegate;

- (void)launchReverseGeocodingForLocation:(CLLocationCoordinate2D)_Location;
- (void)launchFowardGeocoderWithDictionary:(NSDictionary*)_Dictionary;
- (void)cancelCurrentReverseGeocoding;

@end
