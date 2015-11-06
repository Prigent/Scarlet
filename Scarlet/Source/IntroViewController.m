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
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // Optional: Place the button in the center of your view.
    loginButton.center= CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 30);
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends",@"user_photos",@"user_about_me",@"user_hometown",@"user_work_history", @"user_location"];
    loginButton.delegate = self;
    [self.view addSubview:loginButton];
    
     self.mImagePager.paddingControl = 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
    if(error == nil)
    {
        loginButton.hidden = true;
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading";
        
        [[WSManager sharedInstance] authentification:result.token.tokenString completion:^(NSError *error) {
            if(error == nil)
            {
                [hud hide:YES];
                NSLog(@"result %@", result.token.tokenString);
                [self performSegueWithIdentifier:@"showTabView" sender:self];
            }
            else
            {
                [hud hide:YES];
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }
        }];
    }
    else
    {
         [[[UIAlertView alloc] initWithTitle:@"Facebook error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
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
             [UIImage imageNamed:@"scarlet-2"],
             [UIImage imageNamed:@"scarlet-1"]
             ];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}

@end
