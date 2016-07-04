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
#import "Demand.h"
#import "MBProgressHUD.h"
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
    if([[ShareAppContext sharedInstance].user.friends count]>0)
    {
        return 1;
    }
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
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
    ProfileListCell* cellList = (ProfileListCell*)cell;
    
    
    NSMutableArray* lList = [NSMutableArray arrayWithArray:[[ShareAppContext sharedInstance].user.friends array] ];
    NSMutableArray* lRemoveList = [NSMutableArray array];
    for(Profile * lProfile in lList)
    {
        if([lProfile.identifier isEqualToString:self.mEvent.leader.identifier])
        {
            [lRemoveList addObject:lProfile];
            break;
        }
        for(Profile * lPartner in self.mEvent.partners)
        {
            if([lProfile.identifier isEqualToString:lPartner.identifier])
            {
                [lRemoveList addObject:lProfile];
                break;
            }
        }
        for(Demand * lDemand in self.mEvent.demands)
        {
            if([lProfile.identifier isEqualToString:lDemand.leader.identifier])
            {
                [lRemoveList addObject:lProfile];
                break;
            }
            else
            {
                for(Profile * lPartner in lDemand.partners)
                {
                    if([lProfile.identifier isEqualToString:lPartner.identifier])
                    {
                        [lRemoveList addObject:lProfile];
                        break;
                    }
                }
            }
        }
    }

    [lList removeObjectsInArray:lRemoveList];


    [cellList configure:lList andSelectedList:self.listProfileId];

    return cell;
}
- (IBAction)sendRequest:(id)sender {
    
    NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"join_event"  label:nil value:nil] build];
    [[[GAI sharedInstance] defaultTracker]  send:event];
    

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);

    
    [[WSManager sharedInstance] addDemand:self.mEvent partner:self.listProfileId completion:^(NSError *error) {
        [hud hide:YES];
        if(!error)
        {
           [[NSNotificationCenter defaultCenter] postNotificationName:@"eventJoined" object:nil];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
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
