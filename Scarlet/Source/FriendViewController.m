//
//  FriendViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "FriendViewController.h"
#import "WSParser.h"
#import "ShareAppContext.h"
#import "WSManager.h"
#import "Profile.h"
#import "ProfileListCell.h"
#import "User.h"
#import "FriendRequest.h"
#import "ProfileCell.h"
#import "MBProgressHUD.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.mCustomTitle =  NSLocalizedString2(@"friends",nil);
    
    if([ShareAppContext sharedInstance].firstStarted == true)
    {
        [self.navigationItem setHidesBackButton:YES];
        self.title = nil;
        _mButtonBottom.hidden = true;
        
        if(self.type == 2)
        {
            UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
            UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
            [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
            [backButton setTitle:@"" forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            self.navigationItem.leftBarButtonItem = backButtonItem;
            self.mCustomTitle = NSLocalizedString2(@"add_morefriends",nil);//  @"Add more friends";
        }
        else
        {
            UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString2(@"skip",nil) style:UIBarButtonItemStylePlain target:self action:@selector(skip)];
            [anotherButton setTintColor:[UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1]];
            self.navigationItem.rightBarButtonItem = anotherButton;
        }
    }
    else
    {
        [self.mTableView setTableHeaderView:nil];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
        UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
    self.screenName = @"add_more_friends";
    

}

-(void) popBack {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString2(@"loading",nil);
    
    [[ShareAppContext sharedInstance].user.managedObjectContext refreshObject:[ShareAppContext sharedInstance].user mergeChanges:NO];
    
    
    [hud hide:YES];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)acceptInvitation:(NSNotification*) notification
{
    [self respondFriendRequest:notification.object status:kaccept];
}

-(void)declineInvitation:(NSNotification*) notification
{
    [self respondFriendRequest:notification.object status:kreject];
}


-(void) skip
{
    if( self.type == 1)
    {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
        
        [self.navigationController popToRootViewControllerAnimated:false];
    }
    else if( self.type == 2)
    {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
        
        [self.navigationController popViewControllerAnimated:false];
    }
    else
    {
        FriendViewController * lController = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendViewController"];
        lController.type = true;
        [self.navigationController pushViewController:lController animated:true];
    }
}



-(void) updateData
{
    if( self.type == 0 ||  self.type == 1)
    {
        self.mFriendRequestData = [NSArray array];
    }
    else
    {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"type  == 1 AND status != 1  AND status != 2" ];
        self.mFriendRequestData = [[[ShareAppContext sharedInstance].user.friendRequest allObjects] filteredArrayUsingPredicate:bPredicate];
    }
    
    
    self.mSuggestData = [[ShareAppContext sharedInstance].user.suggestProfile allObjects];
    
    if( [self.mSuggestData count] == 0 && self.type == 0)
    {
        self.type = 1;
    }

    
    if(self.type == 0)
    {
        [_mTitleLabel setText:NSLocalizedString2(@"welcome_scarlet",nil)]; //@"Welcome to scarlet"
        [_mSubTitleLabel setText:NSLocalizedString2(@"welcome_scarlet2",nil)]; // @"Few of your friends are already on Scarlet. Invite them now."
    }
    else if(self.type == 1)
    {
        [_mTitleLabel setText:NSLocalizedString2(@"welcome_scarlet3",nil)];//@"More friends is more fun!"
        [_mSubTitleLabel setText:NSLocalizedString2(@"welcome_scarlet4",nil)];//@"Add few friends to have the best scarlet's experience."
    }
    else
    {
        [self.mTableView setTableHeaderView:[[UIView alloc] init]];
    }
    
    [self.mTableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [[self navigationController] setNavigationBarHidden:false animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptInvitation:) name:@"acceptInvitation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(declineInvitation:) name:@"declineInvitation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourFriend:) name:@"yourFriend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectProfile:) name:@"didSelectProfile" object:nil];
    
    
    [self updateData];
    
    [[WSManager sharedInstance] getUserCompletion:^(NSError *error) {
           [self updateData];
    }];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)yourFriend:(NSNotification*) notification
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseViewController* lMain =  [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [lMain configure:notification.object];
    [self.navigationController pushViewController:lMain animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [self.mFriendRequestData count];
    }
    if(section == 1)
    {
        if(self.type == 0)
        {
            return 0;
        }
        return 2;
    }
    if(section == 2)
    {
        if(self.type == 1)
        {
            return 0;
        }
        return [self.mSuggestData count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.type == 1 || self.type == 0)
    {
        return nil;
    }
    
    switch (section) {
        case 0:
            if([self.mFriendRequestData count] == 0)
            {
                return nil;
            }
            
            
            
            return NSLocalizedString2(@"invitation",nil);
        case 1:return nil;
        case 2:
            if([self.mSuggestData count] == 0)
            {
                return nil;
            }
            return NSLocalizedString2(@"facebook_friend",nil);//@"Facebook friend already on Scarlet";
        default:return nil;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 92;
    }
    if(indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                return 55;
                break;
            case 1:
                return 142;
                break;
        }
    }
    else
    {
        return 50;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
        FriendRequest * lFriendRequest = [self.mFriendRequestData objectAtIndex:indexPath.row];
        [cell configure:lFriendRequest.profile];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    if(indexPath.section == 1)
    {
        UITableViewCell* cell = nil;
        switch (indexPath.row)
        {
            case 0:
                cell = [tableView dequeueReusableCellWithIdentifier:@"browseScarlet"];
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"InviteMoreCell"];
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        ProfileCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        [cell configure:[self.mSuggestData objectAtIndex:indexPath.row]];
        
        if(self.type == 2)
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
    }
}


- (IBAction)createScarlet:(id)sender {
    if(self.mTableView.tableHeaderView == nil)
    {
        BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
        
        viewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:viewController animated:true];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)showProfileList:(id)sender {
    
    [self performSegueWithIdentifier:@"showProfileList" sender:self];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    if( indexPath.section == 1 && indexPath.row == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        [self performSegueWithIdentifier:@"showProfileList" sender:self];
    }
    else if (indexPath.section == 2)
    {
        if(self.type == 0)
        {
            UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString2(@"next",nil) style:UIBarButtonItemStylePlain target:self action:@selector(skip)];
            [anotherButton setTintColor:[UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1]];
            self.navigationItem.rightBarButtonItem = anotherButton;
        }
    }
}


-(void) didSelectProfile:(NSNotification* ) notification
{
    Profile* lProfile = notification.object;
    
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"identifier  == %@",lProfile.identifier];
    NSArray * friend = [[lProfile.friends allObjects] filteredArrayUsingPredicate:bPredicate];
    FriendRequest* friendRequest = [lProfile.friendRequests anyObject];
    
    if( [friend count]> 0)
    {
        //@"remove from friends"
    }
    else if (friendRequest)
    {
        if([friendRequest.type intValue] == 0)
        {
            [self removeFriendRequest:friendRequest];
        }
    }
    else
    {
        [self addFriend:lProfile];
    }
}





- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0)
    {
        return false;
    }
    if( indexPath.section == 1 && indexPath.row != 0)
    {
        return false;
    }
    return true;
}

-(void) respondFriendRequest:(NSString*) friendRequestIdentifier status:(StatusType) status
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);

    
    [[WSManager sharedInstance] respondFriend:friendRequestIdentifier status:[NSNumber numberWithInt:status] completion:^(NSError *error) {
        [hud hide:YES];
        if(error == nil)
        {
            [self updateData];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 0, tableView.frame.size.width-16, 34);
    myLabel.font = [UIFont systemFontOfSize:15];
    myLabel.textColor = [UIColor colorWithWhite:68/255. alpha:1];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor =  [UIColor colorWithWhite:245/255. alpha:1];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString* lTitle = [self tableView:tableView titleForHeaderInSection:section];
    if([lTitle length]>0)
    {
        return 34;
    }
    
    return 8;
}
-(void) addFriend:(Profile*) profile
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);

    [[WSManager sharedInstance] addFriend:profile.identifier completion:^(NSError *error) {
        [hud hide:YES];
        if(error == nil)
        {
            [self updateData];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}

-(void) removeFriendRequest:(FriendRequest*) friendRequest
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);
    
    
    [[WSManager sharedInstance] respondFriend:friendRequest.identifier status:[NSNumber numberWithInt:kreject] completion:^(NSError *error) {
        [hud hide:YES];
        if(error == nil)
        {
            [self updateData];
        }
        else
        {
            NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
            NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
            [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}

- (IBAction)sensFacebookInvitation:(id)sender {
    
    
    NSLog(@"facebook %@ %@", NSLocalizedString2(@"facebook_app_url", nil), NSLocalizedString2(@"facebook_image_url", nil));
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:NSLocalizedString2(@"facebook_app_url", nil)];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:NSLocalizedString2(@"facebook_image_url", nil)];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    [FBSDKAppInviteDialog showFromViewController:self withContent:content delegate:self];
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    
}


- (IBAction)sendSMS:(id)sender {
    
    NSString *message = NSLocalizedString2(@"mail_message",nil); //@"Hey, take a look to scarlet APP !"];

    
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    //NSArray *recipents = @[@"12345678", @"72345524"];

    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //[messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}
@end
