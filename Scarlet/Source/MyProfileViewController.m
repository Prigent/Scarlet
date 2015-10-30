//
//  MyProfileViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyProfileViewController.h"
#import "RACollectionViewCell.h"
#import "WSParser.h"
#import "User.h"
#import "Picture.h"
#import "ShareAppContext.h"
#import "UIImageView+AFNetworking.h"
#import "DetailMyProfileCell.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:FALSE animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.mUser = [WSParser getUser:  [ShareAppContext sharedInstance].userIdentifier];
    [self setupPhotosArray];
}


-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat largeCellSideLength = (2.f * ( self.tableview.tableHeaderView.frame.size.width)) / 3.f;
    CGFloat smallCellSideLength = (largeCellSideLength) / 2.f;
    
    self.tableview.tableHeaderView.frame = CGRectMake(0, 0, self.tableview.tableHeaderView.frame.size.width, largeCellSideLength+smallCellSideLength);
    [self.tableview setTableHeaderView:self.tableview.tableHeaderView];
}

- (void)setupPhotosArray
{
    [_photosArray removeAllObjects];
    _photosArray = nil;
    _photosArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 6; i++)
    {
        NSString* photoURL = @"";
        if([self.mUser.pictures count]>i)
        {
            Picture * lPicture = [self.mUser.pictures objectAtIndex:i];
            photoURL = lPicture.filename;
        }
        [_photosArray addObject:photoURL];
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _photosArray.count;
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 5.f;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(5.f, 0, 5.f, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section
{
    return RACollectionViewTripletLayoutStyleSquare; //same as default !
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView
{
    return UIEdgeInsetsMake(64.f, 0, 0, 0);
}

- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview
{
    return .3f;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableview.userInteractionEnabled = false;
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableview.userInteractionEnabled = true;
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    [_photosArray insertObject:image atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSString* urlString =  _photosArray[toIndexPath.item];
    if(urlString.length==0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* urlString =  _photosArray[indexPath.item];
    if(urlString.length==0)
    {
        return NO;
    }
    return YES;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    RACollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.imageView removeFromSuperview];
    cell.imageView.frame = cell.bounds;
    NSString* urlString =  _photosArray[indexPath.item];
    if(urlString.length>0)
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"add-user"];
    }
 
    [cell.contentView addSubview:cell.imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* urlString =  _photosArray[indexPath.item];
    if(urlString.length==0)
    {
        UIActionSheet * lUIActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Library photos", @"Facebook photos", nil];
        [lUIActionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet * lUIActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        [lUIActionSheet showInView:self.view];
    }
}

- (IBAction)refresh:(UIBarButtonItem *)sender
{
    [self setupPhotosArray];
    [self.collectionView reloadData];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 150;
    }
    return 44;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return @"Occupation";
        case 1:return @"About you";
        case 2:return @"Looking for";
        case 3:return @"Aged between";
            
        default:return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailMyProfileCell* cell = nil;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"DetailMyProfileCell"];
            cell.mDetailText.text = self.mUser.occupation;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"DetailMyProfileCell"];
            cell.mDetailText.text = self.mUser.about;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SexCell"];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AgeCell"];
            break;
            
        default:
              cell = [tableView dequeueReusableCellWithIdentifier:@"AgeCell"];
            break;
    }
    if([cell respondsToSelector:@selector(configure:)])
    {
        [cell performSelector:@selector(configure:) withObject:nil];
    }
    return cell;
}


@end
