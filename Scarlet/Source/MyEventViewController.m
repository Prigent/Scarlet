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
    // Do any additional setup after loading the view.
    [self updateView];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:false animated:YES];
    [self.mEventExpendView configure:self.mEvent];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demandSelected:) name:@"demandSelected" object:nil];
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
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];
    
    _mButtonCancel.hidden = true;
    NSInteger status = [self.mEvent getMyStatus] ;
    
    if(status == 1 ||status == 2)
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"event.identifier == %@",self.mEvent.identifier];
        [self updateWithPredicate:lNSPredicate];
        
        
        self.cellIdentifier = @"DemandCell";
    }
    else
    {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"(event.identifier == %@) AND ((leader.identifier == %@) OR ( ANY partners.identifier == %@) )",self.mEvent.identifier, [ShareAppContext sharedInstance].userIdentifier , [ShareAppContext sharedInstance].userIdentifier];
        [self updateWithPredicate:lNSPredicate];
        
        

        self.mHeighEditButton.constant = 0;
        self.title = [NSString stringWithFormat:@"%@'s Scarlet", self.mEvent.leader.firstName];
        
        if(status == 3 || status == 4  || status == 5 )
        {
            _mButtonCancel.hidden = false;
            self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
        
        }
        
        self.cellIdentifier = @"ProfileListCell";
    }
}


- (IBAction)editScarlet:(id)sender {
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    [viewController configure:self.mEvent];
    [self.navigationController pushViewController:viewController animated:true];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 212;
}



-(void) configure:(id) event
{
    self.mEvent = event;
}


- (IBAction)cancelScarlet:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    Demand* lMyDemand = nil;
    
    for(Demand * lDemand in self.mEvent.demands)
    {
        if([lDemand.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
        {
            lMyDemand = lDemand;
        }
    }
    
    [[WSManager sharedInstance] respondDemand:lMyDemand.identifier status:[NSNumber numberWithInt:2] completion:^(NSError *error) {
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:true];
    }];
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
