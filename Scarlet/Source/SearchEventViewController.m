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
    
    [self.mSearchField setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchField.layer.borderWidth = 1;
    self.mSearchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"AllEvent" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];
    
[[WSManager sharedInstance] getUserCompletion:^(NSError *error) {
    [[WSManager sharedInstance] getEventsCompletion:^(NSError *error) {
        if(error)
        {
            NSLog(@"%@", error);
        }
        NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"(!(leader.identifier == %@  OR ANY partners.identifier == %@ OR ANY demands.leader.identifier == %@ OR SUBQUERY(demands, $t, ANY $t.partners.identifier == %@).@count != 0)) AND date >= %@",[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier, [NSDate date]];
        [self updateWithPredicate:lNSPredicate];
    }];
}];
    
    


    
    [self.mMapView setShowsUserLocation:true];
    
    
    if([ShareAppContext sharedInstance].firstStarted == true)
    {
        BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
        viewController.hideBottom = true;
        [self.navigationController pushViewController:viewController animated:false];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventselected:) name:@"eventselected" object:nil];
}

-(void) eventselected:(NSNotification*) notification
{
    self.objectToPush =  @[self.fetchedResultsController, [self.fetchedResultsController indexPathForObject:[notification object]]];
    
    [self performSegueWithIdentifier:@"showEvent" sender:self];
}




-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mSearchField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mSearchField resignFirstResponder];
}

- (IBAction)showList:(id)sender {
    self.mButtonList.selected = true;
    self.mButtonMap.selected = false;
    NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"!(leader.identifier == %@  OR ANY partners.identifier == %@ OR ANY demands.leader.identifier == %@ OR SUBQUERY(demands, $t, ANY $t.partners.identifier == %@).@count != 0)",[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier];
    [self updateWithPredicate:lNSPredicate];

    self.tableView.bounces = true;
    [self.mTableLayoutTop setConstant:0];
    [UIView animateWithDuration:0.4 animations:^{ [self.view layoutIfNeeded]; }];
    
}
- (IBAction)showMap:(id)sender {
    self.mButtonList.selected = false;
    self.mButtonMap.selected = true;
    self.tableView.bounces = false;
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
    
    [self.mTableLayoutTop setConstant:self.view.frame.size.height-44];
    [UIView animateWithDuration:0.4 animations:^{ [self.view layoutIfNeeded]; }];
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

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.objectToPush = @[self.fetchedResultsController,indexPath];
    return indexPath;
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    EventPointAnnotation * lEventPoint = view.annotation;
    NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"identifier == %@", lEventPoint.mEvent.identifier];
    [self updateWithPredicate:lNSPredicate];
    [self.mTableLayoutTop setConstant:self.view.frame.size.height-44-205];
    [UIView animateWithDuration:0.2 animations:^{ [self.view layoutIfNeeded]; }];
    [self.mMapView setCenterCoordinate:view.annotation.coordinate animated:true];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self.mTableLayoutTop setConstant:self.view.frame.size.height-44];
    [UIView animateWithDuration:0.2 animations:^{ [self.view layoutIfNeeded]; }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    EventPointAnnotation * lEventPoint = view.annotation;
    self.objectToPush =  @[self.fetchedResultsController, [self.fetchedResultsController indexPathForObject:lEventPoint.mEvent]];
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
