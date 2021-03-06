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
#import "FriendViewController.h"
#import "WSManager.h"
#import "WSParser.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"


@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString2(@"browse_scarlet",nil);
    [self updateView];
    self.mTableView.alpha = 0;
    
    self.screenName = @"event_detail";
    
    
    
    if(self.mEventId != nil)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString2(@"loading",nil);
        [[WSManager sharedInstance] getEventsCompletion:^(NSError *error)
        {
            [hud hide:YES];
            self.mEvent = [WSParser getEvent:self.mEventId ];
            if(self.mEvent)
            {
                [UIView animateWithDuration:.3 animations:^{  self.mTableView.alpha = 1; } completion:^(BOOL finished) {
                    self.mWhiteView.hidden = true;
                }];
                [self.mTableView reloadData];
            }
            else
            {
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateView];
    
    if(init == false && self.mEventId == nil)
    {
        [self initScroll];
    }
}

-(void) initScroll
{
    init = true;
    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.mIndex.row] atScrollPosition:UITableViewScrollPositionTop animated:false];
    [UIView animateWithDuration:.3 animations:^{  self.mTableView.alpha = 1; } completion:^(BOOL finished) {
        self.mWhiteView.hidden = true;
    }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilelistselected:) name:@"profilelistselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinScarlet:) name:@"joinScarlet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventJoined:) name:@"eventJoined" object:nil];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = false;
}

- (IBAction)addFriends:(id)sender
{
    FriendViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
    viewController.type = 2;
    viewController.hidesBottomBarWhenPushed = YES;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    
    
    [self.navigationController pushViewController:viewController animated:false];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) joinScarlet:(NSNotification*) notification
{
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = true;
    
    [self.mBottomContainer setConstant:-50];
    self.mTableView.alpha = 0.2;
    
    [UIView animateWithDuration:.3 animations:^
    {
        self.mTableView.alpha = 0.2;
        [self.view layoutIfNeeded];
    }];
}


-(void) eventJoined:(NSNotification*) notification
{
    [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]  makeButtonToast:NSLocalizedString2(@"toast_eventjoined", nil)];
    [self closeDemand:nil];
    [self.mTableView reloadData];
}

-(IBAction)closeDemand:(id)sender
{
    self.tabBarController.tabBar.hidden = false;
    [self.mBottomContainer setConstant:-308];
    [UIView animateWithDuration:.3 animations:^{  self.mTableView.alpha = 1; [self.view layoutIfNeeded]; }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.mBottomContainer.constant <= 0)
    {
        [self closeDemand:nil];
    }
}


-(void) profilelistselected:(NSNotification*) notification
{
    if(self.mBottomContainer.constant > -100)
    {
        [self closeDemand:nil];
        return;
    }
    
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
    if([data isKindOfClass:[NSString class]])
    {
        self.mEventId = (NSString*) data;
    }
    else
    {
        self.mData = [data objectAtIndex:0];
        self.mIndex =[data objectAtIndex:1];
    }
}

-(void) updateView
{
    [self.mTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.mEventId != nil && self.mEvent == nil)
    {
        return 0;
    }
    else if(self.mEvent != nil)
    {
        return 1;
    }
    return [self.mData.fetchedObjects count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.mEvent != nil)
    {
        return [NSString stringWithFormat: NSLocalizedString2(@"own_scarlet",nil), self.mEvent.leader.firstName];
    }
    if([self.mData.fetchedObjects count]> section)
    {
        Event* lEvent = [self.mData objectAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0]];
        return [NSString stringWithFormat: NSLocalizedString2(@"own_scarlet",nil), lEvent.leader.firstName]; //'s Scarlet
    }
    else
    {
        return @"";
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.frame.size.height-34;
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
        if(self.mEvent != nil)
        {
            [cell performSelector:@selector(configure:) withObject:self.mEvent];
        }
        else if([self.mData.fetchedObjects count]> indexPath.section)
        {
            Event* lEvent = [self.mData objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];
            [cell performSelector:@selector(configure:) withObject:lEvent];
        }
        else
        {
            [self.mTableView reloadData];
        }
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
