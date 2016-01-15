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
#import "MoodViewController.h"
#import "DateViewController.h"
#import "MapEventCollectionCell.h"
#import "LocationSearchDataSource.h"
#import "WSParser.h"


const int kMaxRadius = 50000;
const int kDefaultRadius = 7000;


@interface SearchEventViewController ()

@end

@implementation SearchEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ShareAppContext sharedInstance].currentRadius = kDefaultRadius;
    [ShareAppContext sharedInstance].currentMood = @"Whatever";
    self.navigationController.navigationBarHidden =true;
    
    [self.mSearchField setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchField.layer.borderWidth = 1;
    self.mSearchField.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    for (id object in [[[self.mSearchField subviews] objectAtIndex:0] subviews])
    {
        if ([object isKindOfClass:[UITextField class]])
        {
            UITextField *textFieldObject = (UITextField *)object;
            textFieldObject.textColor =  [UIColor colorWithWhite:0.2 alpha:0.7];
            textFieldObject.font = [UIFont systemFontOfSize:16];
            textFieldObject.layer.borderColor = [[UIColor colorWithWhite:0.87 alpha:1] CGColor];
            textFieldObject.layer.borderWidth = 1.0;
            textFieldObject.layer.cornerRadius = 2;
            break;
        }
    }
    
    [[WSManager sharedInstance] getUserCompletion:^(NSError *error) {
        
        if(error == nil)
        {
            [self updateData];
        }
    }];
    
    
    
    // Do any additional setup after loading the view.
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"AllEvent" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];


    [self.mMapView setShowsUserLocation:true];
    if([ShareAppContext sharedInstance].firstStarted == true)
    {
        BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
        viewController.hideBottom = true;
        [self.navigationController pushViewController:viewController animated:false];
    }
    
    [self showList:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moodChanged:) name:@"moodFilterChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChanged:) name:@"dateFilterChanged" object:nil];
    
    self.mLocationSearchDataSource=  [[LocationSearchDataSource alloc]init];
    _mLocationSearchDataSource.mTableView = self.mTableViewLocation;
    _mLocationSearchDataSource.mSearchBar = self.mSearchField;
    
    self.mSearchField.delegate = _mLocationSearchDataSource;
    self.mTableViewLocation.dataSource = _mLocationSearchDataSource;
    self.mTableViewLocation.delegate = _mLocationSearchDataSource;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)showFilter:(id)sender {
    
    if(_mTopFilter.constant == 0)
    {
        _mTopFilter.constant = -210;
        if(self.mMapView.hidden == true)
            [UIView animateWithDuration:.3 animations:^{  self.tableView.alpha = 1;[self.view layoutIfNeeded]; }];
        else
            [UIView animateWithDuration:.3 animations:^{  [self.view layoutIfNeeded]; }];
    }
    else
    {
        _mTopFilter.constant = 0;
         if(self.mMapView.hidden == true)
             [UIView animateWithDuration:.3 animations:^{  self.tableView.alpha = 0.2; [self.view layoutIfNeeded]; }];
        else
            [UIView animateWithDuration:.3 animations:^{  [self.view layoutIfNeeded]; }];
    }
}

- (IBAction)cancelFilter:(id)sender
{
    [ShareAppContext sharedInstance].currentRadius = kMaxRadius;
    [ShareAppContext sharedInstance].currentDate = nil;
    [ShareAppContext sharedInstance].currentMood = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFilterValue" object:nil];
    [self updateFilter];
    
    [self showFilter:nil];
}


-(void) updateData
{
    [self.uiRefreshControl beginRefreshing];
    [[WSManager sharedInstance] getProfilsCompletion:^(NSError *error) {
        if(error==nil)
        {
            [[WSManager sharedInstance] getEventsCompletion:^(NSError *error) {
                
                if(error)
                {
                    NSLog(@"%@", error);
                }
                [self updateFilter];
                [self.uiRefreshControl endRefreshing];
            }];
        }
    }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventselected:) name:@"eventselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:@"locationChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterLocation:) name:@"didEnterLocation" object:nil];
    
    
    [self updateFilter];
}

-(void) locationChanged:(NSNotification*) notification
{
    [self.mSearchField setShowsCancelButton:false animated:false];

    if(notification.object == nil)
    {
        self.mLocationSearch = [ShareAppContext sharedInstance].placemark;
    }
    else
    {
        self.mLocationSearch = notification.object;
    }

    NSString *locatedAt = [[self.mLocationSearch.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    if(locatedAt != nil)
    {
        self.mSearchField.text = [[NSString alloc]initWithString:locatedAt];
    }
    
    CLLocationCoordinate2D coordinate = self.mLocationSearch.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate , [ShareAppContext sharedInstance].currentRadius, [ShareAppContext sharedInstance].currentRadius);
    MKCoordinateRegion adjustedRegion = [self.mMapView regionThatFits:viewRegion];
    [self.mMapView setRegion:adjustedRegion animated:YES];
    
    
    [self updateFilter];
    
    [UIView animateWithDuration:.3 animations:^{ self.mTableViewLocation.alpha = 0; }];
}
-(void) didEnterLocation:(NSNotification*) notification
{
     [self.mSearchField setShowsCancelButton:true animated:true];
    [UIView animateWithDuration:.3 animations:^{ self.mTableViewLocation.alpha = 0.8; }];
}




-(void) eventselected:(NSNotification*) notification
{
    self.objectToPush =  @[self.fetchedResultsController, [self.fetchedResultsController indexPathForObject:[notification object]]];
    
    [self performSegueWithIdentifier:@"showEvent" sender:self];
}




-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eventselected" object:nil];
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if(scrollView == self.mMapList)
    {
       NSInteger indexcollect = scrollView.contentOffset.x / scrollView.frame.size.width;

        Event * event = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexcollect];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([event.address.lat doubleValue], [event.address.longi doubleValue]);
        [self.mMapView setCenterCoordinate:coordinate animated:YES];
    }
       
}

- (IBAction)showList:(id)sender {
    
    self.mButtonList.selected = true;
    self.mButtonMap.selected = false;
    

    [self.mTableLayoutTop setConstant:0];
    [UIView animateWithDuration:0.4 animations:^{ [self.view layoutIfNeeded]; } completion:^(BOOL finished) {
        self.mMapView.hidden = true;
        self.mMapList.hidden = true;
    }];
}


- (IBAction)createEvent:(id)sender {
    BaseViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}


-(void) updateFilter
{
    NSArray * lEvents = [WSParser getEvents];
    CLPlacemark* lLocationSearch = self.mLocationSearch;
    if(lLocationSearch == nil)
    {
        lLocationSearch = [ShareAppContext sharedInstance].placemark;
        NSString *locatedAt = [[lLocationSearch.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        if(locatedAt != nil)
        {
            self.mSearchField.text = [[NSString alloc]initWithString:locatedAt];
        }
    }
    

    for(Event* lEvent in lEvents)
    {
        if(lLocationSearch == nil)
        {
            lEvent.distanceCustom =  [NSNumber numberWithDouble:kMaxRadius+1];
        }
        else
        {
            CLLocation * lCLLocationB = [[CLLocation alloc] initWithLatitude:[lEvent.address.lat doubleValue] longitude:[lEvent.address.longi doubleValue]];
            CLLocationDistance distance = [lLocationSearch.location distanceFromLocation:lCLLocationB];
            lEvent.distanceCustom =  [NSNumber numberWithDouble:distance];
        }
    }
    
 
    
    NSString * predicateString = @"(!(leader.identifier == %@  OR ANY partners.identifier == %@ OR ANY demands.leader.identifier == %@ OR SUBQUERY(demands, $t, ANY $t.partners.identifier == %@).@count != 0))AND status == 1";
    predicateString = [predicateString stringByAppendingString:@" AND distanceCustom < %f"];
    
    if([ShareAppContext sharedInstance].currentDate != nil)
    {
        predicateString = [predicateString stringByAppendingString:@" AND date <= %@"];
    }
    if([ShareAppContext sharedInstance].currentMood != nil && ![[ShareAppContext sharedInstance].currentMood isEqualToString:@"Whatever"])
    {
        predicateString = [predicateString stringByAppendingString:[NSString stringWithFormat:@" AND mood == \"%@\"",[ShareAppContext sharedInstance].currentMood ]];
    }
    

    NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:predicateString,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].userIdentifier,[ShareAppContext sharedInstance].currentRadius, [ShareAppContext sharedInstance].currentDate];

    [self updateWithPredicate:lNSPredicate];
    [self performSelector:@selector(updateAnnotation) withObject:nil afterDelay:1];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
    [_mMapList reloadData];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
    [self updateAnnotation];
}

- (IBAction)showMap:(id)sender {
    
    if(self.mMapView.hidden == false)
    {
        [self showList:nil];
        return;
    }
    
    
    self.mButtonList.selected = false;
    self.mButtonMap.selected = true;
    self.mMapView.hidden = false;
    
    self.mMapList.hidden = false;
    
    [self.mTableLayoutTop setConstant:self.view.frame.size.height-44];
    [UIView animateWithDuration:0.4 animations:^{ [self.view layoutIfNeeded]; }];

    
    CLPlacemark* lLocationSearch = self.mLocationSearch;
    if(lLocationSearch == nil)
    {
        lLocationSearch = [ShareAppContext sharedInstance].placemark;
    }
    CLLocationCoordinate2D coordinate = lLocationSearch.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate , [ShareAppContext sharedInstance].currentRadius, [ShareAppContext sharedInstance].currentRadius);
    MKCoordinateRegion adjustedRegion = [self.mMapView regionThatFits:viewRegion];
    [self.mMapView setRegion:adjustedRegion animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:     (NSIndexPath *)indexPath
{
    self.objectToPush =  @[self.fetchedResultsController, indexPath];
    [self performSegueWithIdentifier:@"showEvent" sender:self];
}

-(void) updateAnnotation
{
    
    
    [self.mMapView removeAnnotations:self.mMapView.annotations];
    for( Event * event in [self.fetchedResultsController fetchedObjects])
    {
        EventPointAnnotation *annotation = [[EventPointAnnotation alloc] init];
        annotation.mEvent = event;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([event.address.lat doubleValue], [event.address.longi doubleValue]);
        [annotation setCoordinate: coordinate];
        [annotation setTitle:[NSString stringWithFormat:@"%@ : %@",event.leader.firstName, [event getDateString] ]];
        
        [self.mMapView addAnnotation:annotation];
    }
    
    
    [_mMapList reloadData];
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation {
    if (annotation == self.mMapView.userLocation) return nil;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    
    
    MKAnnotationView *view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(view) return view;
    
    MKAnnotationView* pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    pin.canShowCallout = false;
    pin.image = [UIImage imageNamed:@"icnPinMap"];
    
    
    //UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //customPin.rightCalloutAccessoryView = rightButton;
    
    
    
    return pin;
}

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.objectToPush = @[self.fetchedResultsController,indexPath];
    return indexPath;
}

-(IBAction)selectMood:(id)sender
{
    UIStoryboard * lUIStoryboard = [UIStoryboard storyboardWithName:@"Event" bundle:nil];
    
    
    MoodViewController* lMain =  [lUIStoryboard instantiateViewControllerWithIdentifier:@"MoodViewController"];
    [lMain configure:[ShareAppContext sharedInstance].currentMood];
    lMain.filter = true;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:lMain animated:NO];
}

-(IBAction) selectDate:(id)sender
{
    UIStoryboard * lUIStoryboard = [UIStoryboard storyboardWithName:@"Event" bundle:nil];
    DateViewController* lMain =  [lUIStoryboard instantiateViewControllerWithIdentifier:@"DateViewController"];
    [lMain configure:[ShareAppContext sharedInstance].currentDate];
    lMain.filter = true;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:lMain animated:NO];
}


- (IBAction)changeRadius:(UISlider*)sender {
    [ShareAppContext sharedInstance].currentRadius = sender.value;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFilterValue" object:nil];
    [self updateFilter];
    
    CLLocationCoordinate2D coordinate = _mLocationSearch.location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate , [ShareAppContext sharedInstance].currentRadius, [ShareAppContext sharedInstance].currentRadius);
    MKCoordinateRegion adjustedRegion = [self.mMapView regionThatFits:viewRegion];
    [self.mMapView setRegion:adjustedRegion animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(  collectionView.frame.size.width, collectionView.frame.size.height);
}




-(void) moodChanged:(NSNotification*) notification
{
    [ShareAppContext sharedInstance].currentMood = notification.object;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFilterValue" object:nil];
    [self updateFilter];
}

-(void) dateChanged:(NSNotification*) notification
{
    [ShareAppContext sharedInstance].currentDate = notification.object;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFilterValue" object:nil];
    [self updateFilter];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MapEventCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapEventCollectionCell" forIndexPath:indexPath];
    
    
    [cell configure:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    EventPointAnnotation * lEventPoint = view.annotation;
    NSIndexPath* index = [self.fetchedResultsController indexPathForObject:lEventPoint.mEvent];
    if(index)
    {
        [_mMapList reloadData];
        [_mMapList selectItemAtIndexPath:index animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
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
