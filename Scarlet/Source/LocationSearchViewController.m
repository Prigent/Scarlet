//
//  LocationSearchViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "ShareAppContext.h"
#import "WSManager.h"
#import "LocationSearchDataSource.h"

@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Place";
    
    
    // Do any additional setup after loading the view.
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    
    [self.mSearchBar setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchBar.layer.borderWidth = 1;
    self.mSearchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    self.mLocationSearchDataSource=  [[LocationSearchDataSource alloc]init];
    _mLocationSearchDataSource.mTableView = self.mTableView;
    _mLocationSearchDataSource.mSearchBar = self.mSearchBar;
    
    self.mSearchBar.delegate = _mLocationSearchDataSource;
    self.mTableView.dataSource = _mLocationSearchDataSource;
    self.mTableView.delegate = _mLocationSearchDataSource;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popBack) name:@"locationChanged" object:nil];
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







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
