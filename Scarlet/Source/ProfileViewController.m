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
#import "UIScrollView+APParallaxHeader.h"

static CGFloat kImageOriginHight = 246.f;
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
            self.mProfile = (Profile*)[WSParser getUser:  [ShareAppContext sharedInstance].userIdentifier];
            [self updateView];
        }];
    }
    else
    {
         [self updateView];
    }
    [self.mTableView setTableHeaderView:nil];
    self.mTableView.contentInset = UIEdgeInsetsMake(kImageOriginHight, 0, 0, 0);
    [self.mTableView addSubview:self.mImagePager];
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mImagePager.frame = CGRectMake(0, -kImageOriginHight, self.mTableView.frame.size.width, kImageOriginHight);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    if (yOffset < -kImageOriginHight) {
        CGRect f = self.mImagePager.frame;
        f.origin.y = yOffset;
        f.size.height =  -yOffset;
        self.mImagePager.frame = f;
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
    [self.mImagePager reloadData];
}

- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    NSMutableArray * lData = [NSMutableArray array];
    for(Picture* lImage in self.mProfile.pictures)
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
    if([self.mProfile.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        return 3;
    }
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if([self.mProfile.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:self.mProfile.birthdate toDate:[NSDate date] options:0];
        NSInteger age = [ageComponents year];
        
        ProfileMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMenuCell"];
        switch (indexPath.row) {
            case 0:
                cell.mTitleLabel.text = [NSString stringWithFormat:@"%@, %ld", self.mProfile.firstName,age];
                cell.mSubTitle.text = self.mProfile.occupation;
                break;
            case 1:
                cell.mTitleLabel.text = @"Friends";
                cell.mSubTitle.text = [NSString stringWithFormat:@"%ld", [self.mProfile.friends count]];
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
        NSObject* obj = self.mProfile;
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
    if([self.mProfile.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
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
