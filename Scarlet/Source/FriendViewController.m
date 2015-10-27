//
//  FriendViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "FriendViewController.h"
#import "WSParser.h"
#import "ShareAppContext.h"


@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([ShareAppContext sharedInstance].firstStarted == false)
    {
        [self.navigationItem setHidesBackButton:YES];
        [_mButtonBottom setTitle:@"Do it later" forState:UIControlStateNormal];
    }
    else
    {
        [self.mTableView setTableHeaderView:nil];
    }
    [ShareAppContext sharedInstance].firstStarted = true;
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return @"New invite requests";
        case 1:return @"Invite more friends";
        case 2:return @"Friends suggestion";
        case 3:return @"Your friends";
        default:return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"InviteMoreCell"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
    }
    if([cell respondsToSelector:@selector(configure:)])
    {
        
        [cell performSelector:@selector(configure:) withObject:[WSParser getProfiles]];
    }
    return cell;
}


- (IBAction)createScarlet:(id)sender {
    if(self.mTableView.tableHeaderView == nil)
    {
        BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
        [self.navigationController pushViewController:viewController animated:true];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:true];
    }
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
