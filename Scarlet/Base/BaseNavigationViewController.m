//
//  BaseNavigationViewController.m
//  om
//
//  Created by Prigent ROUDAUT on 05/11/2014.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}


-(BOOL)shouldAutorotate
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
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
