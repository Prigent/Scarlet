//
//  LocationSearchDataSource.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 05/01/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationSearchDataSource : NSObject<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray * mData;
@property (nonatomic, strong) MKLocalSearch * mLocalSearch;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UISearchBar * mSearchBar;
@property (nonatomic, strong) NSTimer * mTimer;
@property (nonatomic, strong) NSString * mLastSearch;

@end
