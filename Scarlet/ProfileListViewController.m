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
    
    
    [self updateWithPredicate:predicate];
    
  
    [self.mSearchField setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchField.layer.borderWidth = 1;
    self.mSearchField.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@", [ShareAppContext sharedInstance].userIdentifier];
        [self updateWithPredicate:predicate];
    }
    else
    {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // self.mProfileToAdd = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    Profile* lProfile =  [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
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
            [self removeFriendRequest:friendRequest];
        }
        else
        {
            //@"respond to friend request"
            //[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Do you want to add %@ in your friend list", self.mProfileToAdd.firstName] message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil]show];
        }
    }
    else
    {
        [self addFriend:lProfile];
        //[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Do you want to add %@ in your friend list", self.mProfileToAdd.firstName] message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil]show];
    }
    
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: [self addFriend:self.mProfileToAdd]; break;
        default:break;
    }
}
*/

-(void) addFriend:(Profile*) profile
{
    [[WSManager sharedInstance] addFriend:profile.identifier completion:^(NSError *error) {
        if(error == nil)
        {
            [self.tableView reloadData];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}

-(void) removeFriendRequest:(FriendRequest*) friendRequest
{
    [[WSManager sharedInstance] respondFriend:friendRequest.identifier status:[NSNumber numberWithInt:kreject] completion:^(NSError *error) {
        
        if(error == nil)
        {
            [self.tableView reloadData];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
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
