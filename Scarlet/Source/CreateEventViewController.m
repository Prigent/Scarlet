//
//  CreateEventViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "CreateEventViewController.h"
#import "WSParser.h"
#import "ProfileListCell.h"

@interface CreateEventViewController ()

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createEvent:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 217;
    }
    return 84;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return @"When";
        case 1:return @"Add friends to your scarlet";
        default:return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];

        ProfileListCell* cellList = (ProfileListCell*)cell;
        [cellList configure:[WSParser getProfiles] type:2];
    }
    return cell;
}

- (IBAction)inviteFriend:(id)sender {
    BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:viewController animated:true];
}


@end
