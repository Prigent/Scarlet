//
//  EventPointAnnotation.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <MapKit/MapKit.h>
@class Event;
@interface EventPointAnnotation : MKPointAnnotation
@property (nonatomic, strong)Event * mEvent;
@end
