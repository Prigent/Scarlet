//
//  MyProfileViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MyProfileViewController.h"
#import "RACollectionViewCell.h"
#import "WSManager.h"
#import "WSParser.h"
#import "User.h"
#import "Picture.h"
#import "ShareAppContext.h"
#import "UIImageView+AFNetworking.h"
#import "DetailMyProfileCell.h"
#import "OLFacebookAlbumRequest.h"
#import "OLFacebookPhotosForAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import "OLFacebookImage.h"
#import "OLFacebookImagePickerController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MBProgressHUD.h"
#import "AgeCell.h"
#import "SexCell.h"


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
    [self setupPhotosArray];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    self.title = @"Edit profile";
}


-(void) popBack {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";

    
    [[WSManager sharedInstance] saveUserCompletion:^(NSError *error) {
        
        
        [hud hide:YES];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
}


-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat largeCellSideLength = (2.f * ( self.tableview.tableHeaderView.frame.size.width)) / 3.f;
    CGFloat smallCellSideLength = (largeCellSideLength) / 2.f;
    
    self.tableview.tableHeaderView.frame = CGRectMake(0, 0, self.tableview.tableHeaderView.frame.size.width, largeCellSideLength+smallCellSideLength+10);
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
        if([[ShareAppContext sharedInstance].user.pictures count]>i)
        {
            Picture * lPicture = [[ShareAppContext sharedInstance].user.pictures objectAtIndex:i];
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
    
    Picture * lPicture = [[ShareAppContext sharedInstance].user.pictures objectAtIndex:fromIndexPath.item];
    [[ShareAppContext sharedInstance].user removeObjectFromPicturesAtIndex:fromIndexPath.item];
    [[ShareAppContext sharedInstance].user insertObject:lPicture inPicturesAtIndex:toIndexPath.item];
    
    
    [self setupPhotosArray];
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
        cell.picto.image = [UIImage imageNamed:@"btnDeletePicture"];
    }
    else
    {
        cell.imageView.image = nil;
        cell.picto.image = [UIImage imageNamed:@"btnAddPicture"];
    }
    [cell.contentView insertSubview:cell.imageView atIndex:0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* urlString =  _photosArray[indexPath.item];
    indexTemp = indexPath.row+1;
    NSLog(@"indexTemp %d", indexTemp);
    
    if(urlString.length==0)
    {
        UIActionSheet * lUIActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", @"Facebook", nil];
        lUIActionSheet.tag = 1;
        [lUIActionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet * lUIActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        
        lUIActionSheet.tag = 2;
        [lUIActionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    if(actionSheet.tag == 1)
    {
        switch (buttonIndex) {
            case 0:
                [self openLibrary:true];
                break;
            case 1:
                [self openLibrary:false];
                break;
            case 2:
                [self openFacebookPicker];
                break;
            default:
                break;
        }
    }
    else
    {
        if(buttonIndex == 0)
        {
            [self deletePicture];
        }
    }
}

-(void) deletePicture
{
    [[WSManager sharedInstance] removePicture:[NSNumber numberWithInt:indexTemp] completion:^(NSError *error) {
        [self setupPhotosArray];
        [self.tableview reloadData];
        [self.collectionView reloadData];
    }];
}

-(void) openLibrary:(BOOL) camera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if(camera)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = nil;
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image==nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(image==nil)
    {
        image = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    [self sendPicture:image];

    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
-(void) openFacebookPicker
{
    OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
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
    if(indexPath.section == 0)
    {
        return 44;
    }
    
    if(indexPath.section == 1)
    {
        return 157;
    }
    return 70;
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
            cell = [tableView dequeueReusableCellWithIdentifier:@"DetailMyProfileCell2"];
            cell.mDetailText.text = [ShareAppContext sharedInstance].user.occupation;
            cell.mDetailText.tag = 2;
            cell.mDetailText.editable = true;
            cell.mDetailText.font = [UIFont systemFontOfSize:17];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"DetailMyProfileCell"];
            cell.mDetailText.text = [ShareAppContext sharedInstance].user.about;
            cell.mDetailText.tag = 1;
            cell.mDetailText.editable = true;
            cell.mCount.text = [NSString stringWithFormat:@"%lu", 220-[[ShareAppContext sharedInstance].user.about length]];
            cell.mDetailText.font = [UIFont systemFontOfSize:17];
            self.count = cell.mCount;
            break;
        case 2:
        {
            SexCell * cellSex = [tableView dequeueReusableCellWithIdentifier:@"SexCell"];
            [cellSex.sexSegment setSelectedSegmentIndex:[[ShareAppContext sharedInstance].user.lookingFor intValue]-1];
             return cellSex;
            break;
        }
        case 3:
        {
            AgeCell * cellAge = [tableView dequeueReusableCellWithIdentifier:@"AgeCell"];
            cellAge.ageSlider.selectedMinimum = [[ShareAppContext sharedInstance].user.ageMin intValue];
            cellAge.ageSlider.selectedMaximum = [[ShareAppContext sharedInstance].user.ageMax intValue];
            return cellAge;
            break;
        }
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 2)
    {
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:true];
    }
    else if(textView.tag == 1)
    {
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:true];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 1)
    {
        [ShareAppContext sharedInstance].user.about = textView.text;
    }
    else if(textView.tag == 2)
    {
        [ShareAppContext sharedInstance].user.occupation = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    textView.font = [UIFont systemFontOfSize:17];
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if(text.length> 0)
    {
        if(textView.tag == 2)
        {
            if(textView.text.length + text.length - range.length > 30)
            {
                return NO;
            }
        }
        if(textView.tag == 1)
        {
            if(textView.text.length + text.length - range.length > 220)
            {
                return NO;
            }
        }
    }

    if(textView.tag == 1)
    {
        
        self.count.text = [NSString stringWithFormat:@"%lu", 220-(textView.text.length + text.length - range.length)];
        
    }

    
    
    return YES;
}

#pragma mark - OLFacebookImagePickerControllerDelegate methods

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^() {
        [[[UIAlertView alloc] initWithTitle:@"Oops" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray *)images {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"User did pick %lu images", (unsigned long) images.count);
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"User cancelled facebook image picking");
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didSelectImage:(OLFacebookImage *)imageFB
{

    
    OLFacebookImage * lOLFacebookImage = imageFB;
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[lOLFacebookImage bestURLForSize:CGSizeMake(800, 800)]]];
    
    [self sendPicture:image];
    
    [imagePicker performSelector:@selector(albumViewControllerDoneClicked:) withObject:imagePicker afterDelay:0];
}


-(void) sendPicture:(UIImage*) image
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    [[WSManager sharedInstance] sendPicture:image position:[NSNumber numberWithInt:indexTemp] completion:^(NSError *error) {
        [self setupPhotosArray];
        [self.tableview reloadData];
        [self.collectionView reloadData];
        [hud hide:YES];
    }];
    
}


- (BOOL)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker shouldSelectImage:(OLFacebookImage *)image
{
    return true;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 10, tableView.frame.size.width-16, 34);
    myLabel.font = [UIFont systemFontOfSize:15];
    myLabel.textColor = [UIColor colorWithWhite:68/255. alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor colorWithWhite:245/255. alpha:1];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString* lTitle = [self tableView:tableView titleForHeaderInSection:section];
    if([lTitle length]>0)
    {
        return 44;
    }
    
    return 8;
}

- (IBAction)ageChanged:(TTRangeSlider*)sender {
    [ShareAppContext sharedInstance].user.ageMax = [NSNumber numberWithInt:sender.selectedMaximum];
    [ShareAppContext sharedInstance].user.ageMin = [NSNumber numberWithInt:sender.selectedMinimum];
}

- (IBAction)sexChanged:(UISegmentedControl*)sender {
    [ShareAppContext sharedInstance].user.lookingFor = [NSNumber numberWithInt:sender.selectedSegmentIndex+1];
}


@end
