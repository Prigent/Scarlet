//
//  LocationSearchViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@class LocationSearchDataSource;

@interface LocationSearchViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (strong, nonatomic)  LocationSearchDataSource* mLocationSearchDataSource;

@end
