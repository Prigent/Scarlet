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

#import "UIImageView+AFNetworking.h"
#import <MapKit/MapKit.h>

@interface MyEventViewController ()

@end

@implementation MyEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateView];
}

-(void) updateView
{
    Picture * picture = [self.mEvent.leader.pictures firstObject];
    [self.mLeaderImage setImageWithURL:[NSURL URLWithString:picture.filename]];
    self.mLeaderLabel.text = [NSString stringWithFormat:@"%@", self.mEvent.leader.name];

    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    CLLocation * lCLLocation = [[CLLocation alloc]initWithLatitude:[self.mEvent.address.lat doubleValue] longitude:[self.mEvent.address.longi doubleValue]];
    
    [geocoder reverseGeocodeLocation:lCLLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark * lCLPlacemark = [placemarks firstObject];
        self.mAddressLabel.text = lCLPlacemark.addressDictionary.description;
    }];
    
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Demand" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];

    

}
-(void) configure:(id) event
{
    self.mEvent = event;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
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