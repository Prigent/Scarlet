//
//  MyEventsViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyEventsViewController.h"
#import "ShareAppContext.h"
#import "WSManager.h"

#import "Event.h"
#import "Demand.h"
#import "Profile.h"


@interface MyEventsViewController ()

@end

@implementation MyEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden =true;
    
    
    [self.mSegmentedControl setSectionTitles:@[NSLocalizedString2(@"incomming",nil),NSLocalizedString2(@"past",nil)] ];
    self.mSegmentedControl.textColor = [UIColor lightGrayColor];
    self.mSegmentedControl.selectedTextColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
    self.mSegmentedControl.selectionIndicatorColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
    self.mSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    self.mSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.mSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 24);
    self.mSegmentedControl.selectedSegmentIndex = 0;
    
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"MyEvent" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] firstObject]];

    [self changeSegment:nil];
    
    
    self.screenName = @"my_events";
}

-(void) updateData
{
    self.fetchedResultsController.delegate = nil;
    [self.uiRefreshControl beginRefreshing];
    
    [[WSManager sharedInstance] getMyEventsCompletion:^(NSError *error) {

        [self.fetchedResultsController performFetch:nil];
        [self.tableView reloadData];
        
        [self.uiRefreshControl endRefreshing];
    }];
}


-(void) eventselected:(NSNotification*) notification
{
    self.objectToPush = [notification object];
    [self performSegueWithIdentifier:@"showMyEvent" sender:self];
}




-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (IBAction)changeSegment:(id)sender {
    
   
    if(self.mSegmentedControl.selectedSegmentIndex == 0)
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"isMine == 1 AND sort == 0"];
        [self updateWithPredicate:lNSPredicate];
        
        self.mEmptyLabel.text = NSLocalizedString2(@"no_event_incomming", nil);
        
    }
    else
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"isMine == 1 AND sort == 1"];
        [self updateWithPredicate:lNSPredicate];
        
        self.mEmptyLabel.text = NSLocalizedString2(@"no_event_history", nil);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event * lEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSInteger status = [lEvent.mystatus integerValue];

    if(status == 1 || status == 2)
    {
        NSInteger countDemand = [lEvent getWaitingDemand];
        if(countDemand == 0)
        {
            return 177;
        }
    }
    
    return 212;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventselected:) name:@"eventselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventedit:) name:@"eventedit" object:nil];
    
    [self.tableView reloadData];
    
    [self updateData];
    
    

    [self changeSegment:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    self.mSegmentedControl.selectedSegmentIndex = 0;
    
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


-(void) eventedit:(NSNotification*) notification
{
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    viewController.hidesBottomBarWhenPushed = true;
    [viewController configure:[notification object]];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:viewController animated:NO];

}


@end
