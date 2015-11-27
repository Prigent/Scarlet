//
//  EventExpendCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "EventExpendCell.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "Address.h"
#import "ProfileCollectionCell.h"

@implementation EventExpendCell

- (void)awakeFromNib {
    // Initialization code
    self.mAnnotation = [[MKPointAnnotation alloc] init];
    [self.mMapView addAnnotation:self.mAnnotation];
}


-(void) configure:(Event*) event
{
    self.mEvent = event;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE, dd/MM/yyyy à HH:mm"];
    
    _mCountPeople.text =  [NSString stringWithFormat:@"%d peoples are in",1];
    _mMood.text =  [NSString stringWithFormat:@"Mood : %@",event.mood];
    _mAddress.text  = [NSString stringWithFormat:@"Near %@",event.address.street];
    _mDate.text = [format stringFromDate:event.date] ;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([event.address.lat doubleValue], [event.address.longi doubleValue]);
    [self.mAnnotation setCoordinate: coordinate];
    [self.mMapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000) animated:true];

    
    NSMutableArray * listProfile = [NSMutableArray array];
    [listProfile addObject:event.leader];
    [listProfile addObjectsFromArray:[event.partners allObjects]];
    
    self.mData = listProfile;
    [self.mCollectionView reloadData];
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



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch ([self.mData count]) {
            
        case 1:
            return  CGSizeMake( collectionView.frame.size.width, collectionView.frame.size.height);
        case 2:
            return  CGSizeMake(  collectionView.frame.size.width/2., collectionView.frame.size.height);
        default:
            return  CGSizeMake(  collectionView.frame.size.width/2.2, collectionView.frame.size.height);
    }
    
    
}

- (IBAction)joinScarlet:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"joinScarlet" object: self.mEvent];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 00.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 00.0;
}
@end
