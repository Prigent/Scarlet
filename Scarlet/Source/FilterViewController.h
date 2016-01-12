//
//  FilterViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 16/12/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *mCurrentRadiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCurrentMoodLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCurrentTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *mCurrentRadiusSlider;

@end
