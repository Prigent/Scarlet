//
//  DemandViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 23/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "DemandViewController.h"
#import "Demand.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "ProfileCollectionCell.h"
#import "WSManager.h"
#import "MBProgressHUD.h"
#import "Event.h"
#import "ShareAppContext.h"


@interface DemandViewController ()

@end

@implementation DemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mData = [[self.mDemand partners] allObjects];
    [self updateView];
}

-(void) updateView
{
    Picture * picture = [self.mDemand.leader.pictures firstObject];
    [self.mLeaderImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:self.mDemand.leader.birthdate
                                       toDate:[NSDate date]
                                       options:0];
    NSInteger age = [ageComponents year];
    self.mLeaderName.text = [NSString stringWithFormat:@"%@, %ld", self.mDemand.leader.firstName,(long)age];
    
    self.title = [NSString stringWithFormat:@"%@'s Team",self.mDemand.leader.firstName];

    if([[ShareAppContext sharedInstance].userIdentifier isEqualToString:self.mDemand.event.leader.identifier])
    {
        self.mAcceptButton.hidden = false;
        self.mDeniedButton.hidden = false;
    }
    else
    {
        self.mAcceptButton.hidden = true;
        self.mDeniedButton.hidden = true;
    }
}
- (IBAction)selectLeader:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.mData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ProfileCollectionCell";
    ProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell configure:[self.mData objectAtIndex:indexPath.row]];

    
    return cell;
}






- (IBAction)acceptDemand:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[WSManager sharedInstance] respondDemand:self.mDemand.identifier status:[NSNumber numberWithInt:1] completion:^(NSError *error) {
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:true];
    }];
}

- (IBAction)rejectDemand:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[WSManager sharedInstance] respondDemand:self.mDemand.identifier status:[NSNumber numberWithInt:2] completion:^(NSError *error) {
        [hud hide:YES];
        [self.navigationController popViewControllerAnimated:true];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) configure:(Demand*) demand
{
    self.mDemand = demand;
}

@end
