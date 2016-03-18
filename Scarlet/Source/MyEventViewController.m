//
//  MyEventViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyEventViewController.h"
#import "Event.h"
#import "Picture.h"
#import "Profile.h"
#import "Address.h"
#import "Demand.h"
#import "ShareAppContext.h"
#import "WSManager.h"

#import "UIImageView+AFNetworking.h"
#import <MapKit/MapKit.h>

#import "MBProgressHUD.h"


@interface MyEventViewController ()

@end

@implementation MyEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSInteger statusEvent = [self.mEvent.mystatus integerValue];
    
    if(statusEvent == 1 || statusEvent == 2 || statusEvent == 3 || statusEvent == 4)
    {
        UIBarButtonItem *openChatButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnChatOn"] style:UIBarButtonItemStylePlain target:self action:@selector(openChat)];
        self.navigationItem.rightBarButtonItem = openChatButtonItem;
    }
    [self.uiRefreshControl removeFromSuperview];
    [self updateView];
    self.screenName = @"my_event_detail";
}



-(void) openChat
{
    BaseViewController *viewController = nil;
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    [viewController configure:self.mEvent.chat];
    [self.navigationController pushViewController:viewController animated:true];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:false animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demandSelected:) name:@"demandSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilelistselected:) name:@"profilelistselected" object:nil];
    
}

- (IBAction)switchHidden:(UISwitch*)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString2(@"loading",nil);
    

    NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"hide_event"  label:nil value:[NSNumber numberWithBool:sender.on]] build];
    [[[GAI sharedInstance] defaultTracker]  send:event];
    
    [[WSManager sharedInstance] hideEvent:self.mEvent status:[NSNumber numberWithBool:sender.on] completion:^(NSError *error) {
        [hud hide:YES];
    }];

}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void) demandSelected:(NSNotification*) notification
{
    self.objectToPush = [notification object];
    [self performSegueWithIdentifier:@"showDemand" sender:self];
}



-(void) updateView
{
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Demand" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] firstObject]];
    
    _mButtonCancel.hidden = true;
    NSInteger status = [self.mEvent.mystatus integerValue];
    
    if(status == 1 ||status == 2)
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"event.identifier == %@",self.mEvent.identifier];
        [self updateWithPredicate:lNSPredicate];
        
        self.title = NSLocalizedString2(@"your_scarlet",nil);//@"Your Scarlet";
        self.cellIdentifier = @"DemandCell";
        
        if(status == 2)
        {
            self.mHeighEditButton.constant = 0;
            CGRect frame = self.tableView.tableHeaderView.frame;
            frame.size.height = 610;
            [self.tableView.tableHeaderView setFrame:frame];
            [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
        }
        else
        {
            CGRect frame = self.tableView.tableHeaderView.frame;
            frame.size.height = 648;
            [self.tableView.tableHeaderView setFrame:frame];
            [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
        }
    }
    else
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"(event.identifier == %@) AND ((leader.identifier == %@) OR ( ANY partners.identifier == %@) )",self.mEvent.identifier, [ShareAppContext sharedInstance].userIdentifier , [ShareAppContext sharedInstance].userIdentifier];
        [self updateWithPredicate:lNSPredicate];
        
        CGRect frame = self.tableView.tableHeaderView.frame;
        frame.size.height = 564;
        [self.tableView.tableHeaderView setFrame:frame];
        [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
        
        
        self.mHeighEditButton.constant = 0;
        self.title = [NSString stringWithFormat: NSLocalizedString2(@"own_scarlet",nil), self.mEvent.leader.firstName];
        
        if(status == 3 || status == 5  || status == 7 )
        {
            _mButtonCancel.hidden = false;
            self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
        }
        
        self.cellIdentifier = @"ProfileListCell";
    }
    [self.mEventExpendView configure:self.mEvent];
    
    
    
    [self.tableView reloadData];
}


- (IBAction)editScarlet:(id)sender {
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    [viewController configure:self.mEvent];
    viewController.hidesBottomBarWhenPushed = true;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    [self.navigationController pushViewController:viewController animated:NO];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}



-(void) configure:(id) event
{
    self.mEvent = event;
}


- (IBAction)cancelScarlet:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString2(@"loading",nil);
    
    Demand* lMyDemand = nil;
    
    for(Demand * lDemand in self.mEvent.demands)
    {
        if([lDemand.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
        {
            lMyDemand = lDemand;
        }
    }
    
    NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"cancel_demand"  label:nil value:nil] build];
    [[[GAI sharedInstance] defaultTracker]  send:event];
    
    [[WSManager sharedInstance] removeDemand:lMyDemand.identifier completion:^(NSError *error) {
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:true];
    }];
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
