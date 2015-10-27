//
//  ProfileViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ProfileViewController.h"
#import "WSManager.h"
#import "WSParser.h"
#import "ShareAppContext.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "ProfileMenuCell.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mImagePager.paddingControl = 16;
    
    if(self.mProfile == nil)
    {
        self.navigationController.navigationBarHidden =true;
        [[WSManager sharedInstance] getUserCompletion:^(NSError *error) {
            self.mUser = [WSParser getUser:  [ShareAppContext sharedInstance].userIdentifier];
            [self updateView];
        }];
    }
    else
    {
         [self updateView];
    }
}

-(void) configure:(id)profile
{
    self.mProfile = profile;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.mProfile == nil)
    {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
}

-(void) updateView
{
    Profile* lCurrentProfile = self.mProfile;
    if(self.mUser != nil)
    {
        lCurrentProfile = (Profile*)self.mUser;
    }
    
    [self.mImagePager reloadData];

 //   [self.mTitle setText: [NSString stringWithFormat:@"%@ %@", lCurrentProfile.name , lCurrentProfile.firstName]];
}

- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    Profile* lCurrentProfile = self.mProfile;
    if(self.mUser != nil)
    {
        lCurrentProfile = (Profile*)self.mUser;
    }
    
    NSMutableArray * lData = [NSMutableArray array];
    for(Picture* lImage in lCurrentProfile.pictures)
    {
        [lData addObject:[lImage filename]];
    }
    return lData;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) imageWithUrl:(NSURL*)url completion:(KIImagePagerImageRequestBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(completion) completion([UIImage imageWithData:imageData],nil);
        });
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.mUser != nil)
    {
        return 3;
    }
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    Profile* lCurrentProfile = self.mProfile;
    if(self.mUser != nil)
    {
        lCurrentProfile = (Profile*)self.mUser;
        
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:lCurrentProfile.birthdate
                                           toDate:[NSDate date]
                                           options:0];
        NSInteger age = [ageComponents year];
        
        ProfileMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMenuCell"];
        switch (indexPath.row) {
            case 0:
                cell.mTitleLabel.text = [NSString stringWithFormat:@"%@, %ld", lCurrentProfile.firstName,age];
                cell.mSubTitle.text = lCurrentProfile.occupation;
                break;
            case 1:
                cell.mTitleLabel.text = @"Friends";
                cell.mSubTitle.text = [NSString stringWithFormat:@"%ld", [lCurrentProfile.friends count]];
                break;
            case 2:
                cell.mTitleLabel.text = @"Parameters";
                cell.mSubTitle.text = @"Notifications, account and others";
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailProfileCell"];
        NSObject* obj = lCurrentProfile;
        if([cell respondsToSelector:@selector(configure:)])
        {
            [cell performSelector:@selector(configure:) withObject:obj];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseViewController *viewController = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:     viewController = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
            break;
        case 1:     viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
            break;
        case 2:     viewController = [[UIStoryboard storyboardWithName:@"Parameter" bundle:nil] instantiateInitialViewController];
            break;
        default:
            break;
    }

    
    [self.navigationController pushViewController:viewController animated:true];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.mUser != nil)
    {
        return 64;
    }
    return 114;
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
