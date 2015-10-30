//
//  SearchEventViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListViewController.h"
#import <MapKit/MapKit.h>

@interface SearchEventViewController : AutoListViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UIButton *mButtonMap;
@property (weak, nonatomic) IBOutlet UIButton *mButtonList;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTableLayoutTop;

@end
