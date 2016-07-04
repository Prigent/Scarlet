//
//  ProfileListViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 03/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ProfileListViewController.h"
#import "WSManager.h"
#import "Profile.h"
#import "ShareAppContext.h"
#import "FriendRequest.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
@interface ProfileListViewController ()

@end

@implementation ProfileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"AllProfile" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] firstObject]];
    
    
    if(self.mData != nil)
    {
        NSMutableArray* array = [NSMutableArray array];
        for(Profile* lProfile in self.mData)
        {
            [array addObject:lProfile.identifier];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@ AND (ANY identifier IN %@)",[ShareAppContext sharedInstance].userIdentifier,array];
        [self updateWithPredicate:predicate];
        _mSearchFriendsLabel.hidden = true;
        self.tableView.hidden = false;
        
        
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
        UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;

        self.cellIdentifier = @"ProfileCell2";
        self.mSearchHeight.constant = 0;
        
        self.screenName = @"chat_profile";
        self.mCustomTitle = NSLocalizedString2(@"chat_profile", nil);
    }
    else
    {
        NSMutableArray* array = [NSMutableArray array];
        for(Profile* lProfile in [ShareAppContext sharedInstance].user.friends)
        {
            [array addObject:lProfile.identifier];
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@ AND ((ANY friendRequests.type == 0) OR friendRequests.@count == 0) AND NOT (identifier IN %@)", [ShareAppContext sharedInstance].userIdentifier,array];
        [self updateWithPredicate:predicate];
        
        
        self.tableView.hidden = true;
        [[WSManager sharedInstance] getProfilsCompletion:^(NSError *error) {
            if(error==nil)
            {
            }
        }];
        
        self.screenName = @"search_profile";
    }

    [self.mSearchField setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchField.layer.borderWidth = 1;
    self.mSearchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    

}

-(void) configure:(NSArray*) data
{
    self.mData = data;
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


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfile:) name:@"didSelectProfile" object:nil];
    self.fetchedResultsController.delegate = self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.fetchedResultsController.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void) updateData
{
    [self.uiRefreshControl beginRefreshing];
    [[WSManager sharedInstance] getProfilsCompletion:^(NSError *error) {
        if(error==nil)
        {
        }
        [self.uiRefreshControl endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _mSearchFriendsLabel.hidden = true;
    if(searchText.length == 0)
    {
        self.tableView.hidden = true;
    }
    else
    {
        self.tableView.hidden = false;
        if(self.mData != nil)
        {
            NSMutableArray* array = [NSMutableArray array];
            for(Profile* lProfile in self.mData)
            {
                [array addObject:lProfile.identifier];
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@ AND  (ANY identifier IN %@) AND (name BEGINSWITH[c] %@  OR firstName BEGINSWITH[c] %@)",[ShareAppContext sharedInstance].userIdentifier, array, searchText , searchText];
            [self updateWithPredicate:predicate];
        }
        else
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@ AND (name BEGINSWITH[c] %@  OR firstName BEGINSWITH[c] %@)", [ShareAppContext sharedInstance].userIdentifier, searchText , searchText];
            [self updateWithPredicate:predicate];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void) didSelectProfile:(NSNotification* ) notification
{
    Profile* lProfile = notification.object;
    if(self.mData != nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BaseViewController* lMain =  [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        [lMain configure:lProfile];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:lMain animated:NO];
    }
    else
    {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"identifier  == %@",lProfile.identifier];
        NSArray * friend = [[lProfile.friends array] filteredArrayUsingPredicate:bPredicate];
        FriendRequest* friendRequest = [lProfile.friendRequests anyObject];
        if( [friend count]> 0)//@"remove from friends"
        {
        }
        else if (friendRequest)
        {
            if([friendRequest.type intValue] == 0)//@"remove friend request for response"
            {
            }
        }
        else
        {
            [self addFriend:lProfile];
        }
    }
}


-(void) addFriend:(Profile*) profile
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);

    NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"add_friend"  label:nil value:nil] build];
    [[[GAI sharedInstance] defaultTracker]  send:event];
    
    
    [[WSManager sharedInstance] addFriend:profile.identifier completion:^(NSError *error) {
        [hud hide:YES];
        if(error == nil)
        {
            [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]  makeButtonToast:NSLocalizedString2(@"toast_friendinvited", nil)];
            [self.tableView reloadData];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}

-(void) removeFriendRequest:(FriendRequest*) friendRequest
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);

    NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"remove_friend"  label:nil value:nil] build];
    [[[GAI sharedInstance] defaultTracker]  send:event];
    
    [[WSManager sharedInstance] respondFriend:friendRequest.identifier status:[NSNumber numberWithInt:kreject] completion:^(NSError *error) {
         [hud hide:YES];
        if(error == nil)
        {
            [self.tableView reloadData];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
