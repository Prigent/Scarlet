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
#import "Demand.h"


@implementation EventExpendView


-(void) configure:(Event*) event
{
    self.mEvent = event;
    
    NSInteger statusEvent = [event.mystatus integerValue];


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
    if(statusEvent == 1 || statusEvent == 2 || statusEvent == 3 || statusEvent == 4)
    {
        _mAddress.text  = [NSString stringWithFormat:@"%@ (%@)",event.address.street,[lMKDistanceFormatter stringFromDistance:[event.distance doubleValue]]];
    }
    else
    {
        _mAddress.text  = [NSString stringWithFormat:@"%@",[lMKDistanceFormatter stringFromDistance:[event.distance doubleValue]]];
    }

    if(statusEvent == 1)
    {
        self.mHideSwitch.enabled = true;
    }
    else
    {
        self.mHideSwitch.enabled = false;
    }
    
    
    if(statusEvent > 1)
    {
        self.mHideSwitch.hidden = true;
        self.mHideLabel.text = @"";
        self.mHideLabel.hidden = true;
        self.mTopSwitch.constant = 0;
    }
    else
    {
        self.mHideSwitch.hidden = false;
        self.mHideLabel.hidden = false;
        self.mTopSwitch.constant = 32;
    }
    
    [_mHideSwitch setOn:[event.status boolValue]];
    
    
    _mDate.text = [event getDateString];
    
    
    _mMapImageView.image = nil;
    

    
    NSString* urlImageBase = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"urlBaseImage"];
    
    NSString* url = [NSString stringWithFormat:@"%@/%@.png",urlImageBase,event.identifier];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData
                                              timeoutInterval:20];
    
    
    [_mMapImageView clearImageCacheForURL:[NSURL URLWithString:url]];

    [_mMapImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
     {
         _mMapImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

    

    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    if(event.leader != nil)
    {
        [listProfile addObject:event.leader];
    }
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
    
    _mBackgroundLabel.hidden = false;
    _mIconLabel.hidden = false;
    _mStatusLabel.hidden = false;
    switch (statusEvent)
    {
        case 1:
        {
            NSInteger countWaiting = [event getWaitingDemand];
            if(countWaiting>0)
            {
                _mStatusLabel.text = [NSString stringWithFormat:@"%ld %@",countWaiting,NSLocalizedString2(@"new_requests", nil)];
                _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
                [_mIconLabel setImage:[UIImage imageNamed:@"icnFriendrequestsScarlet"]];
            }
            else
            {
                _mBackgroundLabel.hidden = true;
                _mIconLabel.hidden = true;
                _mStatusLabel.hidden = true;
            }
            break;
        }
        case 2:
        {
            NSInteger countWaiting = [event getWaitingDemand];
            if(countWaiting>0)
            {
                _mStatusLabel.text = [NSString stringWithFormat:@"%ld %@",countWaiting,NSLocalizedString2(@"new_requests", nil)];
                _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
                [_mIconLabel setImage:[UIImage imageNamed:@"icnFriendrequestsScarlet"]];
            }
            else
            {
                _mBackgroundLabel.hidden = true;
                _mIconLabel.hidden = true;
                _mStatusLabel.hidden = true;
            }
            break;
        }
        case 3:
        case 4:
            _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:116/255. green:196/255. blue:29/255. alpha:1];
            _mStatusLabel.text = NSLocalizedString2(@"scarlet_accepted",nil);//@"Scarlet accepted !";
            [_mIconLabel setImage:[UIImage imageNamed:@"icnScarletStatut"]];
            break;
        case 5:
        case 6:
            _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:245/255. green:166/255. blue:35/255. alpha:1];
            _mStatusLabel.text = NSLocalizedString2(@"scarlet_pending",nil);//@"Scarlet pending !";
            [_mIconLabel setImage:[UIImage imageNamed:@"icnScarletStatut"]];
            break;
        case 7:
        case 8:
            _mBackgroundLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
            _mStatusLabel.text = NSLocalizedString2(@"scarlet_rejected",nil);//@"Scarlet rejected !";
            [_mIconLabel setImage:[UIImage imageNamed:@"icnScarletStatut"]];
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
