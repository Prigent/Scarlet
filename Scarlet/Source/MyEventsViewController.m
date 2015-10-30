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
    
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"MyEvent" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];

    [[WSManager sharedInstance] getMyEventsCompletion:^(NSError *error) {
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"leader.identifier == %@  OR ANY partners.identifier == %@ OR ANY demands.leader.identifier == %@ OR SUBQUERY(demands, $t, ANY $t.partners.identifier == %@).@count != 0",[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier];
            [self updateWithPredicate:lNSPredicate];
        }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
@end
