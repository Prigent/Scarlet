//
//  JoinEventViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "JoinEventViewController.h"
#import "WSParser.h"
#import "WSManager.h"
#import "Event.h"


@interface JoinEventViewController ()

@end

@implementation JoinEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) configure:(id)event
{
    self.mEvent = event;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 165;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Choose your friends";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell  = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
    if([cell respondsToSelector:@selector(configure:)])
    {
        [cell performSelector:@selector(configure:) withObject:[WSParser getProfiles]];
    }
    return cell;
}
- (IBAction)sendRequest:(id)sender {
    
    [[WSManager sharedInstance] addDemand:self.mEvent partner:@[] completion:^(NSError *error) {
         [self.navigationController popToRootViewControllerAnimated:true];
    }];
    
   
    
    
}

@end
