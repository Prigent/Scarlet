//
//  MyChatsViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyChatsViewController.h"
#import "WSManager.h"

@interface MyChatsViewController ()

@end

@implementation MyChatsViewController


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Chat" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] firstObject]];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden =false;
    self.screenName = @"chats";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[WSManager sharedInstance] getChatsCompletion:^(NSError *error) {

        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    NSObject* obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(configure:)])
    {
        [cell performSelector:@selector(configure:) withObject:obj];
    }
    if(indexPath.row == [self.fetchedResultsController.fetchedObjects count]-1)
    {
        if([cell respondsToSelector:@selector(hideBackground)])
        {
            [cell performSelector:@selector(hideBackground) withObject:nil];
        }
    }
    return cell;
}



-(void) updateData
{
    [self.uiRefreshControl beginRefreshing];
    [[WSManager sharedInstance] getChatsCompletion:^(NSError *error) {

        [self.uiRefreshControl endRefreshing];
        
        [self.tableView reloadData];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mSearchField resignFirstResponder];
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
