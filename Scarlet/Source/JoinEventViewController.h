//
//  JoinEventViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class Event;
@interface JoinEventViewController : BaseViewController

@property (nonatomic, strong) Event * mEvent;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (nonatomic, strong) NSMutableArray* listProfileId;


@end
