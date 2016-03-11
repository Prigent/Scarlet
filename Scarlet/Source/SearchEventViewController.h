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


@class LocationSearchDataSource;

@interface SearchEventViewController : AutoListViewController<MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL animatCell;
    BOOL isInit;
}
@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UIButton *mButtonMap;
@property (weak, nonatomic) IBOutlet UIButton *mButtonList;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTableLayoutTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mTopFilter;
@property (weak, nonatomic) IBOutlet UICollectionView *mMapList;
@property (strong, nonatomic) CLPlacemark* mLocationSearch;
@property (strong, nonatomic) NSTimer* mUpdateFilter;
@property (strong, nonatomic) NSTimer* mUpdateSelection;
@property (strong, nonatomic) NSMutableArray* mEventInMap;
@property (strong, nonatomic) NSArray* mEvents;


@property (weak, nonatomic) IBOutlet UITableView *mTableViewLocation;
@property (strong, nonatomic)  LocationSearchDataSource* mLocationSearchDataSource;
@end
