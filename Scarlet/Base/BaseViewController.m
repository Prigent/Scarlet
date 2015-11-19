//
//  BaseViewController.m
//  Voiturescom
//
//  Created by Damien PRACA on 08/10/14.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:false];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:76/255. alpha:1]}];
    
   // self.mLoadingViewGeneric = [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil] objectAtIndex:0];
    CGRect frameLoading = self.view.frame;
    frameLoading.origin.y -= 80;
    frameLoading.size.height += 160;
    frameLoading.origin.x -= 80;
    frameLoading.size.width += 160;
    
    self.mLoadingViewGeneric.frame = frameLoading;
    
    
    [self.view addSubview:self.mLoadingViewGeneric];
    [self updateViewConstraints];
    self.mLoadingViewGeneric.hidden = true;
    self.mIndicatorViewGeneric = (UIActivityIndicatorView*)[self.mLoadingViewGeneric viewWithTag:1];
    self.mTextLoadingGeneric =(UILabel*)[self.mLoadingViewGeneric viewWithTag:2];
 
    for(UITabBarItem* lItem in self.tabBarController.tabBar.items)
    {
        lItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        lItem.titlePositionAdjustment = UIOffsetMake(0, 100);
    }
}

-(BOOL)hidesBottomBarWhenPushed
{
    return self.hideBottom;
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect frameLoading = self.view.frame;
    frameLoading.origin.y -= 80;
    frameLoading.size.height += 160;
    frameLoading.origin.x -= 80;
    frameLoading.size.width += 160;
    
    
    self.mLoadingViewGeneric.frame = frameLoading;
    [self.view layoutIfNeeded];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.customReturn && [self.navigationController.viewControllers count]>1)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Fermer" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    }
}

-(void) close
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    
    [self.navigationController popViewControllerAnimated:false];
}

-(void) configure:(NSDictionary*) dic
{
    self.mViewDictionnary = dic;
    if([dic isKindOfClass:[NSDictionary class]])
    {
        self.title = [NSLocalizedString([dic valueForKey:@"name"], @"") capitalizedString];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)onBackPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


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
