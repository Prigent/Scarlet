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
    
    
    [self.mSegmentedControl setSectionTitles:@[@"INCOMMING",@"PAST"] ];
    self.mSegmentedControl.textColor = [UIColor lightGrayColor];
    self.mSegmentedControl.selectedTextColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
    self.mSegmentedControl.selectionIndicatorColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
    self.mSegmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    self.mSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.mSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 24);
    
    
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"MyEvent" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];

    [self changeSegment:nil];
    
    
    
        [[WSManager sharedInstance] getMyEventsCompletion:^(NSError *error) {
            if(error)
            {
                NSLog(@"%@", error);
            }
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
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"(leader.identifier == %@  OR ANY partners.identifier == %@ OR ANY demands.leader.identifier == %@ OR SUBQUERY(demands, $t, ANY $t.partners.identifier == %@).@count != 0) AND date > %@",[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier, [NSDate date]];
        [self updateWithPredicate:lNSPredicate];
        
    }
    else
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"(leader.identifier == %@  OR ANY partners.identifier == %@ OR ANY demands.leader.identifier == %@ OR SUBQUERY(demands, $t, ANY $t.partners.identifier == %@).@count != 0) AND date <= %@",[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier, [NSDate date]];
        [self updateWithPredicate:lNSPredicate];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event * lEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSInteger status = [lEvent getMyStatus];
    if(status == 2)
    {
        return 177;
    }
    if(status == 1)
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventedit:) name:@"eventedit" object:nil];
    
    
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
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    [self.navigationController pushViewController:viewController animated:true];
}


-(void) eventedit:(NSNotification*) notification
{
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    [viewController configure:[notification object]];
    [self.navigationController pushViewController:viewController animated:true];
}


@end
