//
//  FilterViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 16/12/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "FilterViewController.h"
#import "ShareAppContext.h"


@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFilterValue:) name:@"updateFilterValue" object:nil];
    
    [self updateFilterValue:nil];
}


-(void) updateFilterValue:(id) filterValue
{
    MKDistanceFormatter * lMKDistanceFormatter = [[MKDistanceFormatter alloc]init];
    _mCurrentRadiusLabel.text = [lMKDistanceFormatter stringFromDistance:[ShareAppContext sharedInstance].currentRadius];
    [_mCurrentRadiusSlider setValue:[ShareAppContext sharedInstance].currentRadius];
    
    if( [ShareAppContext sharedInstance].currentMood == nil)
    {
        _mCurrentMoodLabel.text = @"Select your mood";
        _mCurrentMoodLabel.alpha = 0.5;
    }
    else
    {
        _mCurrentMoodLabel.text = [ShareAppContext sharedInstance].currentMood;
        _mCurrentMoodLabel.alpha = 1;
    }

    if( [ShareAppContext sharedInstance].currentDate == nil)
    {
        _mCurrentTimeLabel.text = @"Select your date";
        _mCurrentTimeLabel.alpha = 0.5;
    }
    else
    {
        NSString* datePart = [NSDateFormatter localizedStringFromDate: [ShareAppContext sharedInstance].currentDate dateStyle: NSDateFormatterShortStyle timeStyle: NSDateFormatterShortStyle];
        _mCurrentTimeLabel.text = [datePart capitalizedString];
        _mCurrentTimeLabel.alpha = 1;
    }

}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
