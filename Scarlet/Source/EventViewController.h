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
@interface EventViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    bool init;
}
@property (weak, nonatomic) IBOutlet UIView *mWhiteView;

@property (weak, nonatomic) IBOutlet UITableView *mTableView;


@property (strong, nonatomic) NSFetchedResultsController * mData;
@property (strong, nonatomic) NSIndexPath * mIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mBottomContainer;
@end
