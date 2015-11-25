//
//  LocationSearchViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "LocationSearchViewController.h"
#import "ShareAppContext.h"
#import "WSManager.h"

@interface LocationSearchViewController ()

@end

@implementation LocationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Place";
    
    
    // Do any additional setup after loading the view.
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    
    [self.mSearchBar setBackgroundImage:[[UIImage alloc]init]];
    self.mSearchBar.layer.borderWidth = 1;
    self.mSearchBar.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) popBack {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self search];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self search];
    [self.mSearchBar resignFirstResponder];
}

-(void) search
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.mSearchBar.text;
    
    [self.mLocalSearch cancel];
    self.mLocalSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [self.mLocalSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        // check for error and process the response
        self.mData = response.mapItems;
        [self.mTableView reloadData];
    }];
 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mSearchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    
    MKMapItem * lItem = [self.mData objectAtIndex:indexPath.row];
    CLPlacemark* aPlacemark = lItem.placemark;
    NSString *locatedAt = [[aPlacemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    if(locatedAt != nil)
    {
        cell.textLabel.text =  [[NSString alloc]initWithString:locatedAt];
    }
    else
    {
        cell.textLabel.text =  @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    MKMapItem * lItem = [self.mData objectAtIndex:indexPath.row];
    CLPlacemark* aPlacemark = lItem.placemark;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationChanged" object:aPlacemark];
    [self popBack];
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
