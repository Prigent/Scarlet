//
//  EventViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "EventViewController.h"
#import "Event.h"
#import "Picture.h"
#import "Profile.h"
#import "UIImageView+AFNetworking.h"
#import "Address.h"
#import "ProfileViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Browse Scarlet";
    
    [self updateView];
    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.mIndex.row] atScrollPosition:UITableViewScrollPositionTop animated:false];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilelistselected:) name:@"profilelistselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinScarlet:) name:@"joinScarlet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventJoined:) name:@"eventJoined" object:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) joinScarlet:(NSNotification*) notification
{
    [self.mBottomContainer setConstant:0];
    [UIView animateWithDuration:.3 animations:^{  self.mTableView.alpha = 0.2; [self.view layoutIfNeeded]; }];
}


-(void) eventJoined:(NSNotification*) notification
{
    [[[UIAlertView alloc] initWithTitle:@"Your request has been sent!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self closeDemand:nil];
}

-(IBAction)closeDemand:(id)sender
{
    [self.mBottomContainer setConstant:-308];
    [UIView animateWithDuration:.3 animations:^{  self.mTableView.alpha = 1; [self.view layoutIfNeeded]; }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.mBottomContainer.constant == 0)
    {
        [self closeDemand:nil];
    }
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

-(void) configure:(NSArray*) data
{
    self.mData = [data objectAtIndex:0];
    self.mIndex =[data objectAtIndex:1];
}

-(void) updateView
{
    [self.mTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.mData.fetchedObjects count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Event* lEvent = [self.mData objectAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]];
    return [NSString stringWithFormat:@"%@'s Scarlet", lEvent.leader.firstName];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 0, tableView.frame.size.width-16, 34);
    myLabel.font = [UIFont systemFontOfSize:15];
    myLabel.textColor = [UIColor colorWithWhite:76/255. alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textAlignment = NSTextAlignmentCenter;
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString* lTitle = [self tableView:tableView titleForHeaderInSection:section];
    if([lTitle length]>0)
    {
        return 34;
    }
    
    return 8;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell  = [tableView dequeueReusableCellWithIdentifier:@"EventExpendCell"];
    if([cell respondsToSelector:@selector(configure:)])
    {
        Event* lEvent = [self.mData objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
        [cell performSelector:@selector(configure:) withObject:lEvent];
    }
    return cell;
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

@end
