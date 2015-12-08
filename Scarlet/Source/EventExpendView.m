//
//  EventExpendCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "EventExpendView.h"
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


@implementation EventExpendView


-(void) configure:(Event*) event
{
    self.mEvent = event;
    
    NSInteger statusEvent = [event.mystatus integerValue];

    _mCountPeople.text =  [NSString stringWithFormat:@"%ld peoples are in",[event getCountMember]];
    _mMood.text =  [NSString stringWithFormat:@"Mood : %@",event.mood];
    
    
    if(statusEvent == 1 || statusEvent == 2 || statusEvent == 3 || statusEvent == 4)
    {
        _mAddress.text  = [NSString stringWithFormat:@"Near %@",event.address.street];
    }
    else
    {
        CLLocation * lCLLocationA = [[CLLocation alloc] initWithLatitude:[[ShareAppContext sharedInstance].user.lat doubleValue] longitude:[[ShareAppContext sharedInstance].user.longi doubleValue]];
        CLLocation * lCLLocationB = [[CLLocation alloc] initWithLatitude:[event.address.lat doubleValue] longitude:[event.address.longi doubleValue]];
        CLLocationDistance distance = [lCLLocationA distanceFromLocation:lCLLocationB];
        MKDistanceFormatter * lMKDistanceFormatter = [[MKDistanceFormatter alloc]init];
        _mAddress.text  = [NSString stringWithFormat:@"%@",[lMKDistanceFormatter stringFromDistance:distance]];
    }

    if(statusEvent == 1)
    {
        self.mHideSwitch.enabled = true;
    }
    else
    {
        self.mHideSwitch.enabled = false;
    }
    
    [_mHideSwitch setOn:[event.status boolValue]];
    
    
    _mDate.text = [event getDateString];
    
    
    _mMapImageView.image = nil;
    
    NSString* url = [NSString stringWithFormat:@"%@/homolo/file/scarlet/event/map/%@.png",[WSManager sharedInstance].mBaseURL,event.identifier];
    
    
    [_mMapImageView setImageWithURL:[NSURL URLWithString:url]];

    
    
    
    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    [listProfile addObject:event.leader];
    [listProfile addObjectsFromArray:[event.partners allObjects]];
    
    self.mData = listProfile;
    [self.mCollectionView reloadData];
    
    switch (statusEvent)
    {
        case 1:
        {
            NSInteger countWaiting = [event getWaitingDemand];
            if(countWaiting>0)
            {
                _mStatusLabel.text = [NSString stringWithFormat:@"%ld new requests", countWaiting];
                _mStatusLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
            }
            else
            {
                _mStatusLabel.hidden = true;
            }
            break;
        }
        case 2:
            _mStatusLabel.hidden = true;
            break;
        case 3:
        case 4:
            _mStatusLabel.backgroundColor = [UIColor colorWithRed:116/255. green:196/255. blue:29/255. alpha:1];
            _mStatusLabel.text = @"Scarlet accepted !";
            break;
        case 5:
        case 6:
            _mStatusLabel.backgroundColor = [UIColor colorWithRed:245/255. green:166/255. blue:35/255. alpha:1];
            _mStatusLabel.text = @"Scarlet pending !";
            break;
        case 7:
        case 8:
            _mStatusLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
            _mStatusLabel.text = @"Scarlet rejected !";
            break;
        default:
            break;
    }
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
