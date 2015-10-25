//
//  BaseSplitViewController.m
//  om
//
//  Created by Prigent ROUDAUT on 05/11/2014.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseSplitViewController.h"

@interface BaseSplitViewController ()

@end

@implementation BaseSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationController.automaticallyAdjustsScrollViewInsets = false;
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




- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return UIInterfaceOrientationLandscapeLeft;
    }
    else
    {
        return UIInterfaceOrientationPortrait;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return false;
}









@end
