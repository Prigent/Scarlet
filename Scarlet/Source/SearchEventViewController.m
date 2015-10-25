//
//  SearchEventViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "SearchEventViewController.h"
#import "WSManager.h"
#import "ShareAppContext.h"
#import "Event.h"
#import "Address.h"
#import "Profile.h"
#import "EventPointAnnotation.h"


@interface SearchEventViewController ()

@end

@implementation SearchEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden =true;
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"AllEvent" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];
    
    [[WSManager sharedInstance] getProfilsCompletion:^(NSError *error) {
        [[WSManager sharedInstance] getEventsCompletion:^(NSError *error) {
            NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"leader.identifier != %@", [ShareAppContext sharedInstance].userIdentifier];
            [self updateWithPredicate:lNSPredicate];
        }];
    }];
    
    [self.mMapView setShowsUserLocation:true];
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
- (IBAction)showList:(id)sender {
    self.tableView.hidden = false;
    self.mMapView.hidden = true;
    self.mButtonList.selected = true;
    self.mButtonMap.selected = false;
    
}
- (IBAction)showMap:(id)sender {
    
    self.tableView.hidden = true;
    self.mMapView.hidden = false;
    self.mButtonList.selected = false;
    self.mButtonMap.selected = true;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE, dd/MM/yyyy\nHH:mm"];
    
    
    [self.mMapView removeAnnotations:self.mMapView.annotations];
    for( Event * event in [self.fetchedResultsController fetchedObjects])
    {
        EventPointAnnotation *annotation = [[EventPointAnnotation alloc] init];
        annotation.mEvent = event;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([event.address.lat doubleValue], [event.address.longi doubleValue]);
        [annotation setCoordinate: coordinate];
        
        [annotation setTitle:[NSString stringWithFormat:@"%@ : le %@",event.leader.firstName, [format stringFromDate:event.date] ]];
        
        [self.mMapView addAnnotation:annotation];
    }

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
    if (annotation == self.mMapView.userLocation) return nil;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* customPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    customPin.pinColor = MKPinAnnotationColorRed;
    customPin.animatesDrop = YES;
    customPin.canShowCallout = YES;
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    customPin.rightCalloutAccessoryView = rightButton;
    return customPin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    EventPointAnnotation * lEventPoint = view.annotation;
    
    self.objectToPush = lEventPoint.mEvent;
    [self performSegueWithIdentifier:@"showEvent" sender:self];
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
