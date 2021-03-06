//
//  IntroViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 19/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "IntroViewController.h"
#import "KIImagePager.h"
#import "ShareAppContext.h"
#import "WSManager.h"
#import "MBProgressHUD.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnect) name:@"disconnect" object:nil];
    
    
    self.mFBSDKLoginManager = [[FBSDKLoginManager alloc] init];
    
    self.mFBSDKLoginManager.loginBehavior = FBSDKLoginBehaviorNative;
    
    /*
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center= CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 30);
    loginButton.readPermissions = @[@"user_birthday", @"user_hometown", @"user_location", @"user_work_history", @"user_photos", @"user_friends", @"user_about_me", @"email", @"public_profile", @"user_likes"];
    loginButton.delegate = self;
    [self.view addSubview:loginButton];*/
    
    
    self.screenName = @"login";
    
}
- (IBAction)loginFacebook:(id)sender {
    
    
    if([FBSDKAccessToken currentAccessToken].tokenString !=nil)
    {
        //loginButton.hidden = true;
        [self authentification];
    }
    else
    {
        NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"login_facebook"  label:nil value:nil] build];
        [[[GAI sharedInstance] defaultTracker] send:event];
        
        
        [self.mFBSDKLoginManager logInWithReadPermissions:@[@"user_birthday", @"user_hometown", @"user_location", @"user_work_history", @"user_photos", @"user_friends", @"user_about_me", @"email", @"public_profile", @"user_likes"]
                                  fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                      
                                      if(error == nil && [FBSDKAccessToken currentAccessToken].tokenString !=nil)
                                      {
                                          //loginButton.hidden = true;
                                          [self authentification];
                                      }
                                      else
                                      {
                                          [[[UIAlertView alloc] initWithTitle:NSLocalizedString2(@"facebook_error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
                                      }
                                      
                                  }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.mPageIndicateur.currentPage = page; // you need to have a **iVar** with getter for pageControl
}


-(void) initScrollView
{
    NSArray *viewsToRemove = [_mScrollView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    int countOfInfo = 3;
    for(int i=0; i < countOfInfo; i++)
    {
        UIImageView * lUIImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_mScrollView.frame.size.width*i, 170, _mScrollView.frame.size.width, _mScrollView.frame.size.height-170)];
        lUIImageView.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
        lUIImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ecranOnboarding0%d",i+1]];
        lUIImageView.contentMode = UIViewContentModeScaleAspectFit;
        lUIImageView.clipsToBounds = YES;
        
        
        
        UILabel* lLabel =  [[UILabel alloc] initWithFrame:CGRectMake(_mScrollView.frame.size.width*i +16, 0,  _mScrollView.frame.size.width-32, 170)];
        lLabel.numberOfLines = 0;
        lLabel.textColor = [UIColor whiteColor];
        lLabel.font = [UIFont systemFontOfSize:25];
        lLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString * lKey = [NSString stringWithFormat:@"ecranOnboarding0%d",i+1];
        
        lLabel.text = NSLocalizedString2(lKey, nil);
        [_mScrollView addSubview:lLabel];
        [_mScrollView addSubview:lUIImageView];
    }

    [_mScrollView setContentSize:CGSizeMake(_mScrollView.frame.size.width*countOfInfo, _mScrollView.frame.size.height)];
}

-(void) disconnect
{
    [self dismissViewControllerAnimated:true completion:^{
        
        
        NSManagedObjectContext *managedObjectContext = [ShareAppContext sharedInstance].managedObjectContext;

        // retrieve the store URL
        NSURL * storeURL = [[managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
        // lock the current context
        
        [managedObjectContext performBlockAndWait:^{
            
            NSError * error;
            [managedObjectContext reset];//to drop pending changes
            //delete the store from the current managedObjectContext
            if ([[managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
            {
                // remove the file containing the data
                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
                //recreate the store like in the  appDelegate method
                [[managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
            }
        }];
        

        [self.mFBSDKLoginManager logOut];
        
        
    }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(willShowTab == true)
    {
        [self showTab];
        didShowTab = true;
    }

}



-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(didShowTab == true)
    {
        didShowTab = false;
        return;
    }
    if([[[ShareAppContext sharedInstance] accessToken] length]>0)
    {
        [self performSegueWithIdentifier:@"showTabView" sender:self];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);

    [[WSManager sharedInstance] getTextCompletion:^(NSError *error) {
        [self initScrollView];
            [hud hide:YES];
        
        [self.mFacebookButton setTitle:NSLocalizedString2(@"login_facebook", nil) forState:UIControlStateNormal];
        self.mFacebookDetail.text = NSLocalizedString2(@"login_facebook_detail", nil);
        
    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self authentification];
}

-(void) authentification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString2(@"loading",nil);
    

    [[WSManager sharedInstance] authentification: [FBSDKAccessToken currentAccessToken].tokenString completion:^(NSError *error) {
        [hud hide:YES];
        if(error == nil)
        {
            willShowTab = true;
            BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Tutorial" bundle:nil] instantiateInitialViewController];
            [self presentViewController:viewController animated:true completion:^{
                
            }];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            UIAlertView  * lUIAlertView = [[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString2(@"retry",nil), nil];
            [lUIAlertView show];
        }
    }];
}


-(void) showTab
{
    willShowTab = false;
    [self performSegueWithIdentifier:@"showTabView" sender:self];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return @[
             [UIImage imageNamed:@"ecranOnboarding01"],
             [UIImage imageNamed:@"ecranOnboarding02"],
             [UIImage imageNamed:@"ecranOnboarding03"]
             ];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeBottom;
}

@end
