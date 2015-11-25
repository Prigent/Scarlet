//
//  CreateEventViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "BaseViewController.h"

@interface CreateEventViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * mood;
@property (nonatomic, strong) NSString * address;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableArray* listProfileId;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
