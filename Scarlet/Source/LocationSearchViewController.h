//
//  LocationSearchViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface LocationSearchViewController : BaseViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (nonatomic, strong) NSArray * mData;
@property (nonatomic, strong) MKLocalSearch * mLocalSearch;

@end
