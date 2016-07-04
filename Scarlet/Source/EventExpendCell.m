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
#import "WSManager.h"
#import "User.h"
#import <MapKit/MapKit.h>
#import "ShareAppContext.h"
#import "Demand.h"


@implementation EventExpendCell


-(void) configure:(Event*) event
{
    self.mEvent = event;

    NSInteger countMember = [event getCountMember];
    if(countMember >1 )
    {
        _mCountPeople.text =  [NSString stringWithFormat:@"%ld %@",[event getCountMember], NSLocalizedString2(@"people_are", nil)]; //peoples are in
    }
    else
    {
        _mCountPeople.text =  [NSString stringWithFormat:@"%ld %@",[event getCountMember],NSLocalizedString2(@"people_is", nil)];
    }

    _mMood.text =  [NSString stringWithFormat:@"%@ : %@",NSLocalizedString2(@"mood", nil),event.mood];
    

    MKDistanceFormatter * lMKDistanceFormatter = [[MKDistanceFormatter alloc]init];
    _mAddress.text  = [NSString stringWithFormat:@"%@",[lMKDistanceFormatter stringFromDistance:[event.distance doubleValue]]];
    

    _mDate.text = [event getDateString];
    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    [listProfile addObject:event.leader];
    [listProfile addObjectsFromArray:[event.partners allObjects]];
    
    for(Demand * lDemand in event.demands)
    {
        if([lDemand.status integerValue] == 1)
        {
            [listProfile addObject:lDemand.leader];
            [listProfile addObjectsFromArray:[lDemand.partners allObjects]];
        }
    }
    
    
    
    self.mData = listProfile;
    [self.mCollectionView reloadData];
    
    _mMapImageView.image = nil;
    

    NSString* urlImageBase = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"urlBaseImage"];
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.png",urlImageBase,event.identifier];
    [_mMapImageView setImageWithURL:[NSURL URLWithString:url]];
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
