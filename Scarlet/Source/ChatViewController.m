//
//  ChatViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ChatViewController.h"
#import "WSManager.h"
#import "Chat.h"
#import "Message.h"
#import "ProfileViewController.h"
#import "ShareAppContext.h"
#import "Profile.h"
#import "Event.h"
#import "NSData+Base64.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "WSParser.h"

@interface ChatViewController ()

@end

@implementation ChatViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] firstObject]];
    
    self.tableView.alpha = 0;
    self.mBottomView.alpha = 0;
    
    NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"chat.identifier == %@", self.mChat.identifier];
    [self updateWithPredicate:lNSPredicate];
    
   
    [self updateData];
    
    NSString * customTitle= self.mChat.event.leader.firstName;
    for(int i=0 ; i< [self.mChat.event.partners count] ; i++)
    {
        Profile* lProfile = [[self.mChat.event.partners allObjects]objectAtIndex:i];
        if( i == [self.mChat.event.partners count]-1)
        {
            customTitle = [NSString stringWithFormat:@"%@ %@ %@",customTitle , NSLocalizedString2(@"and", @"and"), lProfile.firstName ];
        }
        else
        {
            customTitle = [NSString stringWithFormat:@"%@, %@",customTitle, lProfile.firstName ];
        }
    }
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 23.0f, 23.0f)];
    UIImage *settingImage = [[UIImage imageNamed:@"btnSettings"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23.0f, 0, 23.0f)];
    [settingButton setBackgroundImage:settingImage  forState:UIControlStateNormal];
    [settingButton setTitle:@"" forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.rightBarButtonItem = settingButtonItem;

    
    
    self.mCustomTitle = customTitle;
    self.screenName = @"chat_detail";
}




-(void) setting {
    
    [_mTextField resignFirstResponder];
    [[[UIActionSheet alloc] initWithTitle:NSLocalizedString2(@"setting_chat_title", nil) delegate:self cancelButtonTitle:NSLocalizedString2(@"setting_chat_cancel", nil) destructiveButtonTitle:NSLocalizedString2(@"setting_chat_exit", nil) otherButtonTitles:NSLocalizedString2(@"setting_chat_flagging", nil), nil] showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString2(@"loading", nil);
        
        [[WSManager sharedInstance] chatOut:self.mChat.identifier completion:^(NSError *error) {
            [hud hide:YES];
            if(error == nil)
            {
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    }
    if( buttonIndex == 1)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString2(@"loading", nil);
        
        
        [[WSManager sharedInstance] flagging:@"chat" identifier:self.mChat.identifier completion:^(NSError *error) {
            [hud hide:YES];
            if(error == nil)
            {
                [self.view makeToast:NSLocalizedString2(@"chat_flagging_toast", nil)];
            }
        }];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateData) object:nil];
    [self performSelector:@selector(updateData) withObject:nil afterDelay:5];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_mTextField resignFirstResponder];
}


-(void) updateData
{
    if(isUpdating == false)
    {
        
        isUpdating = true;
        NSInteger currentCount = [self.mChat.messages count];
        if(self.tableView.alpha != 0)
        {
            [self.uiRefreshControl beginRefreshing];
        }
        [[WSManager sharedInstance] getMessagesForChat:self.mChat completion:^(NSError *error) {
            
            isUpdating = false;
            

            if(self.tableView.alpha != 0)
            {
                [self.uiRefreshControl endRefreshing];
            }
            
            NSInteger newCount = [self.mChat.messages count];
            if(self.tableView.alpha == 0 || currentCount != newCount)
            {
                [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.5];
            }
            
            
            
            
            for(Message* lMessage in self.mChat.messages)
            {
                lMessage.readStatus = [NSNumber numberWithBool:true];
            }
            [self.tableView reloadData];
            
            [[WSManager sharedInstance]updateCountRead];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateData) object:nil];
            [self performSelector:@selector(updateData) withObject:nil afterDelay:5];
        }];
        
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateData) object:nil];
        [self performSelector:@selector(updateData) withObject:nil afterDelay:5];
    }
    
}


-(void) scrollToBottom
{
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height)
    {
        CGFloat yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:(self.tableView.alpha == 1)];
    }
    self.tableView.alpha = 1;
    self.mBottomView.alpha = 1;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectProfile:) name:@"selectProfile" object:nil];
    
    [self.tableView reloadData];
}

-(void) selectProfile:(NSNotification*) notification
{
    Message* lMessage = notification.object;
    if(![lMessage.owner.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        BaseViewController* lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [lMain configure:lMessage.owner];
        [self.navigationController pushViewController:lMain animated:true];
    }
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    

    
    [_mBottomLayout setConstant:(8+keyboardFrame.size.height)];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     } completion:^(BOOL finished) {
                         CGPoint offset = CGPointMake(0, self.tableView.contentSize.height -     self.tableView.frame.size.height);
                         if(offset.y>0)
                         {
                             [self.tableView setContentOffset:offset animated:YES];
                         }
                     }];
}

-(void)keyboardOffScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    NSLog(@"keyboardFrame: %@", NSStringFromCGRect(keyboardFrame));
    
    [_mBottomLayout setConstant:8];
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (IBAction)sendMessage:(id)sender {

    if([self.mTextField.text length]>0)
    {
        NSString * message = self.mTextField.text;
        [self.mTextField setText:nil];
        
        NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"send_message"  label:nil value:nil] build];
        
        [self.mChat addMessagesObject:[WSParser addMyMessageTmp:message]];
        
        [self.tableView reloadData];
        [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.3];
        
        
        [[[GAI sharedInstance] defaultTracker] send:event];
        
        
        [[WSManager sharedInstance] addMessage:self.mChat message:message completion:^(NSError *error) {
        }];
    }
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mTextField resignFirstResponder];
}*/



-(void) configure:(Chat*) chat
{
    self.mChat = chat;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell* cell = nil;
    Message* message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    int date = 60*10;
    if(indexPath.row > 0)
    {
        Message* messageBefore = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        date = message.date.timeIntervalSince1970 - messageBefore.date.timeIntervalSince1970;
    }
    

    
    if([message.owner.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        if(date >= (60*10))
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@2WithDate",self.cellIdentifier]];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@2",self.cellIdentifier]];
        }

    }
    else
    {
        if(date >= (60*10))
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@WithDate",self.cellIdentifier]];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        }

    }
    

    if([cell respondsToSelector:@selector(configure:)])
    {
        [cell performSelector:@selector(configure:) withObject:message];
    }
    
    return cell;
}


-(BOOL)isBase64Data:(NSString *)input
{
    
    input=[[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
    if ([input length] % 4 == 0) {
        static NSCharacterSet *invertedBase64CharacterSet = nil;
        if (invertedBase64CharacterSet == nil) {
            invertedBase64CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="]invertedSet];
        }
        return [input rangeOfCharacterFromSet:invertedBase64CharacterSet options:NSLiteralSearch].location == NSNotFound;
    }
    return NO;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message* message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    int date = 60*10;
    if(indexPath.row > 0)
    {
        Message* messageBefore = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        date = message.date.timeIntervalSince1970 - messageBefore.date.timeIntervalSince1970;
    }
    
    NSString* text =message.text;
    if([self isBase64Data:message.text])
    {
        NSData *data = [NSData dataFromBase64String:message.text];
        NSString *valueUnicode = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData *dataa = [valueUnicode dataUsingEncoding:NSUTF8StringEncoding];
        NSString *valueEmoj = [[NSString alloc] initWithData:dataa encoding:NSNonLossyASCIIStringEncoding];
        text = valueEmoj;
    }

    
    if([message.owner.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width  - 28 ,1000);
        CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        if(date >= (60*10))
        {
            return 20+expectedLabelSize.height +40;
        }
        else
        {
            return 20+expectedLabelSize.height;
        }
    }
    else
    {
        CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width  - 38-8-28 ,1000);
        CGSize expectedLabelSize = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        
        if(date >= (60*10))
        {
            return 50+expectedLabelSize.height +40;
        }
        else
        {
            return 50+expectedLabelSize.height;
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
