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
#import "FriendViewController.h"
#import "User.h"
#import "MBProgressHUD.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.mImagePager.paddingControl = 16;
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    

    if(self.mProfile == nil)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading";
        
        isUser=true;
        [[self navigationController] setNavigationBarHidden:true animated:false];
        [[WSManager sharedInstance] getUserCompletion:^(NSError *error) {
            
            [hud hide:YES];
            self.mProfile = (Profile*)[ShareAppContext sharedInstance].user;
            [self updateView];
        }];
    }
    else
    {
        self.title = self.mProfile.firstName;
        [[WSManager sharedInstance] getMutualfriend:self.mProfile completion:^(NSError *error) {
            
            [self.mTableView reloadData];
        }];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
        UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }

    [self.mTableView addSubview:self.mImagePager];
}





-(void) popBack {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) profilelistselected:(NSNotification*) notification
{
    id data = [notification object];

    if([data isKindOfClass: [Profile class]])
    {
        Profile * profile = (Profile*)data;
        BaseViewController* lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        [lMain configure:profile];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:lMain animated:NO];
    }
}



- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isUser == true)
    {
        if(  indexPath.section == 2) // (indexPath.section == 1 && indexPath.row == 1) ||
        {
            return true;
        }
    }

    return false;
}

/*
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
*/

-(void) configure:(id)profile
{
    self.mProfile = profile;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(isUser)
    {
        [[self navigationController] setNavigationBarHidden:true animated:YES];
    }
    else
    {
        [[self navigationController] setNavigationBarHidden:false animated:YES];
    }
    [self updateView];
    
    [self.mTableView.tableHeaderView setFrame:CGRectMake(0, 0, self.mTableView.frame.size.width, self.mTableView.frame.size.width)];
    [self.mTableView setTableHeaderView:self.mTableView.tableHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilelistselected:) name:@"profilelistselected" object:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) updateView
{
    [self.mImagePager reloadData];
    [self.mTableView reloadData];
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
    if(isUser)
    {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 2;
                break;
            case 2:
                return 1;
                break;
            default:
                break;
        }
        return 3;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isUser)
    {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(isUser)
    {
        if(indexPath.section == 0)
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailProfileCell"];
            NSObject* obj = self.mProfile;
            if([cell respondsToSelector:@selector(configure:)])
            {
                [cell performSelector:@selector(configure:) withObject:obj];
            }
            
            return cell;
        }
        if(indexPath.section == 1)
        {
        if(indexPath.row == 0)
            {
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
                if([cell respondsToSelector:@selector(configure:)])
                {
                    [cell performSelector:@selector(configure:) withObject:[[ShareAppContext sharedInstance].user.friends allObjects]];
                }
                return cell;
            }
       if(indexPath.row == 1)
            {
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddMoreFriend"];
                
                return cell;
            }
        }
        if(indexPath.section == 2)
        {

                ProfileMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMenuCell"];
                cell.mTitleLabel.text = @"Parameters";
                cell.mSubTitle.text = @"Notifications, account and others";
                return cell;
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailProfileCell"];
            NSObject* obj = self.mProfile;
            if([cell respondsToSelector:@selector(configure:)])
            {
                [cell performSelector:@selector(configure:) withObject:obj];
            }
            
            return cell;
        }
        else if(indexPath.row == 1)
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MutualListCell"];
            if([cell respondsToSelector:@selector(configure:)])
            {
                [cell performSelector:@selector(configure:) withObject:[self.mProfile.mutualFriends allObjects]];
            }
            return cell;
        }
        else if(indexPath.row == 2)
        {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"InterestListCell"];
            if([cell respondsToSelector:@selector(configure:)])
            {
                [cell performSelector:@selector(configure:) withObject:[self.mProfile.interests allObjects]];
            }
            return cell;
        }

    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(isUser)
    {
        if(indexPath.section == 2)
        {
        FriendViewController *viewController = nil;
        viewController = [[UIStoryboard storyboardWithName:@"Parameter" bundle:nil] instantiateInitialViewController];
        
        [self.navigationController pushViewController:viewController animated:true];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) return 1;
    return 16;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    if(section == 0) return v;
    
    /*v.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    v.layer.borderWidth = 1;*/
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    rightBorder.borderWidth = 1;
    rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(tableView.frame)+2,16+2);
    [v.layer addSublayer:rightBorder];
    
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isUser)
    {
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            int size = 57;
            if([self.mProfile.occupation length]> 0)
            {
                size += 14;
            }
            if([self.mProfile.about length]> 0)
            {
               
                if(isUser)
                {
                    size += 20;
                }
                else
                {
                    CGSize constraint = CGSizeMake(tableView.frame.size.width - 16, 20000.0f);
                    
                    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
                    CGSize boundingBox = [self.mProfile.about boundingRectWithSize:constraint
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                           context:context].size;
                    size += ceil(boundingBox.height);
                }
            }
            return size;
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                return 165;
            }
            else
            {
                return 58;
            }
        }
        else
        {
            return 45;
        }
    }
    else
    {
        if(indexPath.row == 0 && indexPath.section == 0)
        {
            int size = 57;
            if([self.mProfile.occupation length]> 0)
            {
                size += 20;
            }
            if([self.mProfile.about length]> 0)
            {
                size += 50;
            }
            return size;
        }
        if(indexPath.row == 1)
        {
            if([self.mProfile.mutualFriends count]>0)
            {
                return 165;
            }
            else
            {
                return 0;
            }
        }
        if(indexPath.row == 2)
        {
            if([self.mProfile.interests count]>0)
            {
                return 73;
            }
            else
            {
                return 0;
            }
        }
    }
    return 0;
}
- (IBAction)editProfile:(id)sender {

    FriendViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil] instantiateInitialViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    [self.navigationController pushViewController:viewController animated:NO];
}


- (IBAction)addFriends:(id)sender
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
