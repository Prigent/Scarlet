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


@interface ProfileListViewController ()

@end

@implementation ProfileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"AllProfile" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier != %@", [ShareAppContext sharedInstance].userIdentifier];
    [self updateWithPredicate:predicate];
    
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
    self.mProfileToAdd = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Do you want to add %@ in your friend list", self.mProfileToAdd.firstName] message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil]show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: [self addFriend:self.mProfileToAdd]; break;
        default:break;
    }
}

-(void) addFriend:(Profile*) profile
{
    [[WSManager sharedInstance] addFriend:profile.identifier completion:^(NSError *error) {
        if(error != nil)
        {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ added", self.mProfileToAdd.firstName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
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

@end
