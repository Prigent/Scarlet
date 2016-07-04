//
//  MyEventsViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoListViewController.h"
#import "HMSegmentedControl.h"


@interface MyEventsViewController : AutoListViewController
@property (weak, nonatomic) IBOutlet HMSegmentedControl *mSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *mCreateScarletButton;
@property (weak, nonatomic) IBOutlet UILabel *mEmptyLabel;

@end
