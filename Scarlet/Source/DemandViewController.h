//
//  DemandViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 23/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Demand;
@interface DemandViewController : UIViewController

@property (strong, nonatomic) Demand * mDemand;

@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mLeaderImage;

@end
