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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kAlertViewTag_noLocation)
    {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}


- (IBAction)createEvent:(id)sender {
    
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            UIAlertView * lUIAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString2(@"miss_location_title", @"") message:NSLocalizedString2(@"miss_location_desc", @"") delegate:self cancelButtonTitle:NSLocalizedString2(@"miss_location_cancel", @"") otherButtonTitles:NSLocalizedString2(@"miss_location_ok", @""), nil];
            lUIAlertView.tag = kAlertViewTag_noLocation;
            [lUIAlertView show];
            return;
        }
    }
    
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    
    viewController.hidesBottomBarWhenPushed = true;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    [self.navigationController pushViewController:viewController animated:NO];
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
