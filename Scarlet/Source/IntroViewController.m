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
    
    
    /*
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center= CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 30);
    loginButton.readPermissions = @[@"user_birthday", @"user_hometown", @"user_location", @"user_work_history", @"user_photos", @"user_friends", @"user_about_me", @"email", @"public_profile", @"user_likes"];
    loginButton.delegate = self;
    [self.view addSubview:loginButton];*/
    
}
- (IBAction)loginFacebook:(id)sender {
    
    
    if([FBSDKAccessToken currentAccessToken].tokenString !=nil)
    {
        //loginButton.hidden = true;
        [self authentification];
    }
    else
    {
        
        [self.mFBSDKLoginManager logInWithReadPermissions:@[@"user_birthday", @"user_hometown", @"user_location", @"user_work_history", @"user_photos", @"user_friends", @"user_about_me", @"email", @"public_profile", @"user_likes"]
                                  fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                      
                                      if(error == nil && [FBSDKAccessToken currentAccessToken].tokenString !=nil)
                                      {
                                          //loginButton.hidden = true;
                                          [self authentification];
                                      }
                                      else
                                      {
                                          [[[UIAlertView alloc] initWithTitle:@"Facebook error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
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
    int countOfInfo = 3;
    for(int i=0; i < countOfInfo; i++)
    {
        UIImageView * lUIImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_mScrollView.frame.size.width*i, 170, _mScrollView.frame.size.width, _mScrollView.frame.size.height-170)];
        lUIImageView.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
        lUIImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ecranOnboarding0%d",i+1]];
        lUIImageView.contentMode = UIViewContentModeScaleAspectFit;
        lUIImageView.clipsToBounds = YES;
        
        
        
        UILabel* lLabel =  [[UILabel alloc] initWithFrame:CGRectMake(_mScrollView.frame.size.width*i, 0,  _mScrollView.frame.size.width, 170)];
        lLabel.numberOfLines = 0;
        lLabel.textColor = [UIColor whiteColor];
        lLabel.font = [UIFont systemFontOfSize:25];
        lLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString * lKey = [NSString stringWithFormat:@"ecranOnboarding0%d",i+1];
        
        lLabel.text = NSLocalizedString(lKey, nil);
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


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    if([[[ShareAppContext sharedInstance] accessToken] length]>0)
    {
        [self performSegueWithIdentifier:@"showTabView" sender:self];
    }
    
    [self initScrollView];


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
    hud.labelText = @"Loading";
    

    [[WSManager sharedInstance] authentification: [FBSDKAccessToken currentAccessToken].tokenString completion:^(NSError *error) {
        if(error == nil)
        {
            [hud hide:YES];
            [self performSegueWithIdentifier:@"showTabView" sender:self];
        }
        else
        {
            [hud hide:YES];
            UIAlertView  * lUIAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"Retry", nil];
            [lUIAlertView show];
        }
    }];
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
