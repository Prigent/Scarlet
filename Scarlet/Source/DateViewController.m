//
//  DateViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString2(@"time", nil);
    
    // Do any additional setup after loading the view.
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    if(self.mDate == nil)
    {
        self.mDate = [NSDate date];
    }
    [self.mDatePicker setDate:self.mDate animated:true];
    
    NSString* datePart = [NSDateFormatter localizedStringFromDate: self.mDate dateStyle: kCFDateFormatterMediumStyle timeStyle: NSDateFormatterShortStyle];
    _mDateLabel.text = [datePart capitalizedString];
    
    [self.mDatePicker setMinimumDate:[NSDate date]];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString2(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(save)];

    self.screenName = @"select_date";
}


-(void) save {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}


-(void) configure:(id)date
{
    self.mDate = date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) popBack {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)pickDate:(UIDatePicker*)sender {
    
    
    self.mDate = sender.date;
    
    
    NSString* datePart = [NSDateFormatter localizedStringFromDate: self.mDate dateStyle: kCFDateFormatterMediumStyle timeStyle: NSDateFormatterShortStyle];
    _mDateLabel.text = [datePart capitalizedString];
    


    
    if(self.filter)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dateFilterChanged" object:self.mDate];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dateChanged" object:self.mDate];
    }

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
