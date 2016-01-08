//
//  EventCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "EventCell.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "Address.h"
#import "ProfileCollectionCell.h"
#import "ShareAppContext.h"
#import <MapKit/MapKit.h>
#import "User.h"


@implementation EventCell




-(void) configure:(Event*) event
{
    self.mEvent = event;
    _mTitle.text = event.leader.firstName;
    for(Profile * lPartner in event.partners)
    {
        _mTitle.text = [_mTitle.text stringByAppendingString:[NSString stringWithFormat:@", %@",lPartner.firstName]];
    }
    
 

    

    MKDistanceFormatter * lMKDistanceFormatter = [[MKDistanceFormatter alloc]init];
    _mSubtitle.text  = [NSString stringWithFormat:@"%@, %@",[lMKDistanceFormatter stringFromDistance:[event.distance doubleValue]] ,[event getDateString]];
    
    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    [listProfile addObject:event.leader];
    [listProfile addObjectsFromArray:[event.partners allObjects]];
    
    self.mData = listProfile;
    [self.mCollectionView reloadData];
    self.mCount.text = [NSString stringWithFormat:@"%ld", [self.mData count]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.mData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ProfileCollectionCell";
    ProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell configure:[self.mData objectAtIndex:indexPath.row]];
    cell.mEvent = self.mEvent;
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
