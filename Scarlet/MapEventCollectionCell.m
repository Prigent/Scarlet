//
//  MapEventCollectionCell.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 21/12/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MapEventCollectionCell.h"
#import "Event.h"
#import "Profile.h"
#import "ProfileCollectionCell.h"
#import <MapKit/MapKit.h>

@implementation MapEventCollectionCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer* lGesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEvent:)];
    
    [self.mCollectionView addGestureRecognizer:lGesture];
 }


- (IBAction)selectEvent:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eventselected" object:self.mEvent];
}

-(void) configure:(Event*) event
{
    self.mEvent = event;
    NSMutableArray * listProfile = [NSMutableArray array];
    if(event.leader)
        [listProfile addObject:event.leader];
    [listProfile addObjectsFromArray:[event.partners allObjects]];
    
    self.mData = listProfile;

    
    
    for(int i=0 ; i< [self.mData count] ; i++)
    {
        Profile* lProfile = [self.mData objectAtIndex:i];
        i++;
        if( i == 1)
        {
            self.mTitleLabel.text = lProfile.firstName;
        }
        else if( i == [self.mData count])
        {
          self.mTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.mTitleLabel.text ,  NSLocalizedString(@"and", @"and"), lProfile.firstName ];
        }
        else
        {
            self.mTitleLabel.text = [NSString stringWithFormat:@"%@, %@",self.mTitleLabel.text, lProfile.firstName ];
        }
    }
    
    
    MKDistanceFormatter * lMKDistanceFormatter = [[MKDistanceFormatter alloc]init];
    self.mSubTitleLabel.text  = [NSString stringWithFormat:@"%@, %@",[lMKDistanceFormatter stringFromDistance:[event.distance doubleValue]] ,[event getDateString]];
    

    
    
    [_mCollectionView reloadData];
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if([self.mData count]< 5)
    {
        return UIEdgeInsetsMake(0, collectionView.frame.size.width/2. - (80*[self.mData count])/2., 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
