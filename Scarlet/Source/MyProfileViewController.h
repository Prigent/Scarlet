//
//  MyProfileViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RACollectionViewReorderableTripletLayout.h"

@class User;
@interface MyProfileViewController : BaseViewController<RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource, UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    NSInteger indexTemp;
    BOOL dontEndEditing;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;
@end
