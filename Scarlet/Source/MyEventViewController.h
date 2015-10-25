//
//  MyEventViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListViewController.h"

@class Event;
@interface MyEventViewController : AutoListViewController

@property (strong, nonatomic) Event* mEvent;

@property (weak, nonatomic) IBOutlet UILabel *mAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mLeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *mLeaderLabel;

@end
