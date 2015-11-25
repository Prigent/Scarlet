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
    _mTitle.text = event.leader.firstName;
    for(Profile * lPartner in event.partners)
    {
        _mTitle.text = [_mTitle.text stringByAppendingString:[NSString stringWithFormat:@", %@",lPartner.firstName]];
    }
    
    _mSubtitle.text  = [NSString stringWithFormat:@"%@",event.address.street];
    
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEEE, dd/MM/yyyy\nHH:mm"];
    _mDate.text = [format stringFromDate:event.date];
    _mStatusLabel.text = @"";
    
    
    NSMutableArray * listProfile = [NSMutableArray array];
    [listProfile addObject:event.leader];
    [listProfile addObjectsFromArray:[event.partners allObjects]];
    self.mData = listProfile;
    [self.mCollectionView reloadData];
    
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
    

    if([event.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        _mStatusLabel.text = @"Leader";
        return;
    }

    NSPredicate *predPart = [NSPredicate predicateWithFormat:@"identifier == %@",[ShareAppContext sharedInstance].userIdentifier];
    NSArray *matchesPart = [[event.partners allObjects] filteredArrayUsingPredicate:predPart];
    if([matchesPart count]>0)
    {
        _mStatusLabel.text = @"Partner";
        return;
    }

    
    for(Demand * lDemand in event.demands)
    {
        if([lDemand.leader.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
        {
            switch ([lDemand.status integerValue]) {
                case 1: _mStatusLabel.text = @"accepted";break;
                case 2: _mStatusLabel.text = @"rejected";break;
                case 3: _mStatusLabel.text = @"waiting"; break;
                default:break;
            }
            return;
        }
        
        for(Profile* lProfile in lDemand.partners)
        {
            if([lProfile.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
            {
                switch ([lDemand.status integerValue]) {
                    case 1: _mStatusLabel.text = @"accepted";break;
                    case 2: _mStatusLabel.text = @"rejected";break;
                    case 3: _mStatusLabel.text = @"waiting"; break;
                    default:break;
                }
                return;
            }
        }
    }
}



-(void) reloadData
{
    [self.mCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.mData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ProfileCollectionCell";
    ProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if([self.mData count]>indexPath.row)
    {
        [cell configure:[self.mData objectAtIndex:indexPath.row]];
    }
    else
    {
        [self.mCollectionView reloadData];
    }

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
