//
//  EventViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"


@class Event;
@interface EventViewController : BaseViewController

@property (strong, nonatomic) Event * mEvent;

@property (weak, nonatomic) IBOutlet UIImageView *mLeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *mLeaderTitle;
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UILabel *mMoodLabel;

@end
