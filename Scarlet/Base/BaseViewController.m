//
//  BaseViewController.m
//  Voiturescom
//
//  Created by Damien PRACA on 08/10/14.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"
#import "FriendViewController.h"

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
   // if(self.navigationItem.backBarButtonItem !=nil)
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
  //  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
 //   self.navigationController.navigationBar.topItem.title = @"";
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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString2(@"close", nil) style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    }
    
    if(self.mCustomTitle.length>0 )
    {
        [self setTitle:self.mCustomTitle];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirection:) name:@"redirection" object:nil];
}


-(void) redirection:(NSNotification*) notification
{
    NSNumber* number= [notification object];
    if([number intValue] < 4)
    {
        [self.tabBarController setSelectedIndex:[number intValue]];
        UINavigationController * lnav = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:[number intValue]];
        if( [lnav isKindOfClass:[UINavigationController class]])
        {
            [lnav popToRootViewControllerAnimated:false];
        }
    }
    else if([number intValue] == 4)
    {
        FriendViewController *viewController = nil;
        viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
        viewController.type = 2;
        
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        
        
        
        [self.navigationController pushViewController:viewController animated:false];
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([self observationInfo]) {
        @try {
             [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"redirection"];
        }
        @catch (NSException *exception) {}
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
        self.mCustomTitle =  NSLocalizedString2([dic valueForKey:@"name"],[dic valueForKey:@"name"]);
        self.title = self.mCustomTitle;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    UIViewController* lNext = [segue destinationViewController];
    if([lNext isKindOfClass:[UINavigationController class]])
    {
        lNext =  [(UINavigationController*)lNext topViewController];
    }
    if([lNext respondsToSelector:@selector(configure:)])
    {
        [lNext performSelector:@selector(configure:) withObject:self.objectToPush];
    }
}



@end
