//
//  IntroViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BaseViewController.h"
#import "KIImagePager.h"
@interface IntroViewController : BaseViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *mPageIndicateur;
@property (strong, nonatomic) FBSDKLoginManager * mFBSDKLoginManager;
@end
