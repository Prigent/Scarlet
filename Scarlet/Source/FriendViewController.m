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

@interface FriendViewController ()

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [WSParser getUser:[ShareAppContext sharedInstance].userIdentifier];
    if([ShareAppContext sharedInstance].firstStarted == false)
    {
        [self.navigationItem setHidesBackButton:YES];
        [_mButtonBottom setTitle:@"Do it later" forState:UIControlStateNormal];
    }
    else
    {
        [self.mTableView setTableHeaderView:nil];
    }
    [ShareAppContext sharedInstance].firstStarted = true;
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    [[self navigationController] setNavigationBarHidden:false animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newInviteRequest:) name:@"newInviteRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(friendSuggestion:) name:@"friendSuggestion" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourFriend:) name:@"yourFriend" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)newInviteRequest:(NSNotification*) notification
{
    self.mDataToRespond = notification.object;
    FriendRequest* fr = self.mDataToRespond;
    
    UIAlertView * lUIAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Do you want to accept %@ as your friend?", fr.profile.firstName] message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", @"NO", nil];
    lUIAlertView.tag = 1;
    [lUIAlertView show];
}

-(void)friendSuggestion:(NSNotification*) notification
{
    self.mDataToRespond = notification.object;
    Profile* profile = self.mDataToRespond;
    
    UIAlertView * lUIAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Do you want to add %@ in your friend list?", profile.firstName] message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    lUIAlertView.tag = 2;
    [lUIAlertView show];
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 134;
    }
    return 84;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return @"New invite requests";
        case 1:return @"Invite more friends";
        case 2:return @"Your friends";
        case 3:return @"Friends suggestion";
        default:return @"";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
            ProfileListCell* cellList = (ProfileListCell*)cell;
            [cellList configure:[self.mUser.friendRequest allObjects] type:0];}
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"InviteMoreCell"];
            break;
        case 2:{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
            ProfileListCell* cellList = (ProfileListCell*)cell;
            [cellList configure:[self.mUser.friends allObjects] type:1];}
            break;
        default:
            break;
    }

    return cell;
}


- (IBAction)createScarlet:(id)sender {
    if(self.mTableView.tableHeaderView == nil)
    {
        BaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Event" bundle:nil] instantiateInitialViewController];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case 1:
            
            switch (buttonIndex) {
                case 1: [self respondFriendRequest:self.mDataToRespond status:kaccept]; break;
                case 2: [self respondFriendRequest:self.mDataToRespond status:kreject]; break;
                default:break;
            }
            
            
            break;
        case 2:
            
            switch (buttonIndex) {
                case 1: [self addFriend:self.mDataToRespond]; break;
                default:break;
            }
            
            break;
        case 3:break;
        default:break;
    }
   
}


-(void) respondFriendRequest:(FriendRequest*) friendRequest status:(StatusType) status
{
    [[WSManager sharedInstance] respondFriend:friendRequest.identifier status:[NSNumber numberWithInt:status] completion:^(NSError *error) {
        if(error != nil)
        {
            if(status == kaccept)
            {
                [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ ajouter", friendRequest.profile.firstName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ refuser", friendRequest.profile.firstName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
            }
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];
}

-(void) addFriend:(Profile*) profile
{
    [[WSManager sharedInstance] addFriend:profile.identifier completion:^(NSError *error) {
        if(error != nil)
        {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ added", profile.firstName] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
        }
    }];

}
- (IBAction)sensFacebookInvitation:(id)sender {
    
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://www.scarlet.com/scarlet"];
    //optionally set previewImageURL
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.scarlet.com/scarlet.jpg"];
    
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
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    //NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Hey, take a look to scarlet APP !"];
    
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
