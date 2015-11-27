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
#import "ProfileListCell.h"
#import "ShareAppContext.h"
#import "User.h"

@interface JoinEventViewController ()

@end

@implementation JoinEventViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.listProfileId = [NSMutableArray array];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinScarlet:) name:@"joinScarlet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectProfile:) name:@"selectProfile" object:nil];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) joinScarlet:(NSNotification*)notification
{
    self.mEvent = [notification object];
    [self.mTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    return 145;
    
    return 64;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1)
    {
        return  [tableView dequeueReusableCellWithIdentifier:@"AddMoreFriend"];
    }
    
    UITableViewCell* cell  = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
    ProfileListCell* cellList = (ProfileListCell*)cell;
    [cellList configure:[[ShareAppContext sharedInstance].user.friends allObjects] andSelectedList:self.listProfileId];

    return cell;
}
- (IBAction)sendRequest:(id)sender {
    
    [[WSManager sharedInstance] addDemand:self.mEvent partner:self.listProfileId completion:^(NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"eventJoined" object:nil];
    }];
}


-(void) selectProfile:(NSNotification*) notification
{
    id data = [notification object];
    
    if([data isKindOfClass: [Profile class]])
    {
        Profile * profile = (Profile*)data;
        if([self.listProfileId containsObject:profile.identifier])
        {
            [self.listProfileId removeObject:profile.identifier];
        }
        else
        {
            [self.listProfileId addObject:profile.identifier];
        }
        [self.mTableView reloadData];
    }
}




@end
