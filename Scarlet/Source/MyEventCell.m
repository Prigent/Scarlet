//
//  MyEventCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyEventCell.h"
#import "Event.h"
#import "UIImageView+AFNetworking.h"
#import "Profile.h"
#import "Picture.h"
#import "ShareAppContext.h"
#import "Demand.h"
#import "ProfileCollectionCell.h"
#import "Address.h"
#import "User.h"
#import <MapKit/MapKit.h>
#import "ShareAppContext.h"


@implementation MyEventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) configure:(Event*) event
{
    self.mEvent = event;
    NSInteger statusEvent = [event.mystatus integerValue];
 
    _mTitle.text = event.leader.firstName;
    for(Profile * lPartner in event.partners)
    {
        _mTitle.text = [_mTitle.text stringByAppendingString:[NSString stringWithFormat:@", %@",lPartner.firstName]];
    }
    
    

    if(statusEvent == 1 || statusEvent == 2 || statusEvent == 3 || statusEvent == 4)
    {
        _mSubtitle.text  = [NSString stringWithFormat:@"%@",event.address.street];
    }
    else
    {
        MKDistanceFormatter * lMKDistanceFormatter = [[MKDistanceFormatter alloc]init];
        _mSubtitle.text  = [NSString stringWithFormat:@"%@",[lMKDistanceFormatter stringFromDistance:[event.distance doubleValue]]];
    }


    _mDate.text = [event getDateString];
    _mStatusLabel.text = @"";
    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    if(event.leader !=nil)
    {
           [listProfile addObject:event.leader]; 
    }

    [listProfile addObjectsFromArray:[event.partners allObjects]];
    self.mData = listProfile;
    [self.mCollectionView reloadData];
     _mStatusLabel.hidden = false;
    _mButtonEdit.hidden = true;
    switch (statusEvent)
    {
        case 1:
        {
            _mButtonEdit.hidden = false;
            NSInteger countWaiting = [event getWaitingDemand];
            if(countWaiting>0)
            {
                _mStatusLabel.text = [NSString stringWithFormat:@"%ld %@",countWaiting,NSLocalizedString2(@"new_requests", nil)];
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
            _mStatusLabel.text = NSLocalizedString2(@"scarlet_accepted",nil);//@"Scarlet accepted !";
            break;
        case 5:
        case 6:
            _mStatusLabel.backgroundColor = [UIColor colorWithRed:245/255. green:166/255. blue:35/255. alpha:1];
            _mStatusLabel.text = NSLocalizedString2(@"scarlet_pending",nil);//@"Scarlet pending !";
            break;
        case 7:
        case 8:
            _mStatusLabel.backgroundColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
            _mStatusLabel.text = NSLocalizedString2(@"scarlet_rejected",nil);//@"Scarlet rejected !";
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

- (IBAction)openEvent:(id)sender {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"eventselected" object:self.mEvent];
}
- (IBAction)editEvent:(id)sender {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"eventedit" object:self.mEvent];
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
