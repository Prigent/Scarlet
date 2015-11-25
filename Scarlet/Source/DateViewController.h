//
//  DateViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "BaseViewController.h"

@interface DateViewController : BaseViewController
@property (nonatomic, strong) NSDate * mDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *mDateLabel;
@end
