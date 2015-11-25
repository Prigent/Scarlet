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

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateView];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}

-(void) configure:(Event*) event
{
    self.mEvent = event;
}

-(void) updateView
{
    Picture * picture = [self.mEvent.leader.pictures firstObject];
    [self.mLeaderImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    self.mMoodLabel.text = [NSString stringWithFormat:@"%@", self.mEvent.mood];
    self.mLeaderTitle.text =[NSString stringWithFormat:@"%@ %@", self.mEvent.leader.name, self.mEvent.leader.firstName];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.mEvent.address.lat doubleValue], [self.mEvent.address.longi doubleValue]);
    [annotation setCoordinate: coordinate];
    [self.mMapView addAnnotation:annotation];
    
    [self.mMapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000) animated:true];
}


- (IBAction)showLeaderProfile:(id)sender {

    BaseViewController* lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [lMain configure:self.mEvent.leader];
    [self.navigationController pushViewController:lMain animated:true];
    
}

- (IBAction)joinScarlet:(id)sender {
   
    self.objectToPush = self.mEvent;
    [self performSegueWithIdentifier:@"showJoin" sender:self];
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
