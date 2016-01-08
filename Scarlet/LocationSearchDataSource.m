//
//  LocationSearchDataSource.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 05/01/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import "LocationSearchDataSource.h"

@implementation LocationSearchDataSource

-(id) init
{
    if ((self = [super init])) {
        //self.mTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(searchLocation) userInfo:nil repeats:true];
    }
    return self;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterLocation" object:nil];
    return true;
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
    
    [self.mSearchBar resignFirstResponder];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(searchLocation) withObject:nil afterDelay:0.3];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void) searchLocation
{
    if([self.mSearchBar.text length] == 0 && self.mLastSearch !=nil)
    {
        self.mLastSearch = nil;
        self.mData = @[];
        [self.mTableView reloadData];
    }
    else if(![self.mSearchBar.text isEqualToString:self.mLastSearch])
    {
        [self search:self.mSearchBar];
    }
}

-(void) search:(UISearchBar *)searchBar
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery =searchBar.text;
    self.mLastSearch = searchBar.text;

    [self.mLocalSearch cancel];
    self.mLocalSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [self.mLocalSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         self.mData = response.mapItems;
         NSLog(@"search %@",self.mData);
         [self.mTableView reloadData];
     }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_mSearchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationChanged" object:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mSearchBar resignFirstResponder];
}



@end
