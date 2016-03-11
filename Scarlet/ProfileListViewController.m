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
@interface ProfileListViewController ()

@end

@implementation ProfileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"AllProfile" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];
    
    
    NSMutableArray* array = [NSMutableArray array];
    for(Profile* lProfile in [ShareAppContext sharedInstance].user.friends)
    {
        [array addObject:lProfile.identifier];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@ AND ((ANY friendRequests.type == 0) OR friendRequests.@count == 0) AND NOT (identifier IN %@)", [ShareAppContext sharedInstance].userIdentifier,array];
    
    self.tableView.hidden = true;
    [self updateWithPredicate:predicate];
    [[WSManager sharedInstance] getProfilsCompletion:^(NSError *error) {
        if(error==nil)
        {
        }
    }];
  
    [self.mSearchField setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchField.layer.borderWidth = 1;
    self.mSearchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.screenName = @"search_profile";
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfile:) name:@"didSelectProfile" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@ AND (name BEGINSWITH[c] %@  OR firstName BEGINSWITH[c] %@)", [ShareAppContext sharedInstance].userIdentifier, searchText , searchText];
        [self updateWithPredicate:predicate];
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
    
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"identifier  == %@",lProfile.identifier];
    
    NSArray * friend = [[lProfile.friends allObjects] filteredArrayUsingPredicate:bPredicate];
    
    FriendRequest* friendRequest = [lProfile.friendRequests anyObject];
    
    if( [friend count]> 0)
    {
        //@"remove from friends"
    }
    else if (friendRequest)
    {
        if([friendRequest.type intValue] == 0)
        {
            //@"remove friend request for response"
           // [self removeFriendRequest:friendRequest];
        }
        else
        {
        }
    }
    else
    {
        [self addFriend:lProfile];
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
