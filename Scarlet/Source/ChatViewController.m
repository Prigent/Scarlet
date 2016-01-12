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

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"];
    [super configure:[[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0]];
    
    
    
    NSPredicate * lNSPredicate = [NSPredicate predicateWithFormat:@"chat.identifier == %@", self.mChat.identifier];
    [self updateWithPredicate:lNSPredicate];
    
   
    [self updateData];
    
    NSString * customTitle= self.mChat.event.leader.firstName;
    for(int i=0 ; i< [self.mChat.event.partners count] ; i++)
    {
        Profile* lProfile = [[self.mChat.event.partners allObjects]objectAtIndex:i];
        i++;
        if( i == [self.mChat.event.partners count])
        {
            customTitle = [NSString stringWithFormat:@"%@ %@ %@",customTitle , NSLocalizedString(@"and", @"and"), lProfile.firstName ];
        }
        else
        {
            customTitle = [NSString stringWithFormat:@"%@, %@",customTitle, lProfile.firstName ];
        }
    }
    self.title = customTitle;
}



-(void) updateData
{
    if(!self.uiRefreshControl.isRefreshing)
    {
        [self.uiRefreshControl beginRefreshing];
        [[WSManager sharedInstance] getMessagesForChat:self.mChat completion:^(NSError *error) {
            if(error)
            {
                NSLog(@"%@", error);
            }
            [self performSelector:@selector(scroolToBottom) withObject:nil afterDelay:0.5];
            [self.uiRefreshControl endRefreshing];
            
            
            //[self performSelector:@selector(updateData) withObject:nil afterDelay:10];
            
            [self.tableView reloadData];
        }];
    }
}


-(void) scroolToBottom
{
    CGFloat yOffset = 0;
    
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    }
    
    [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardOffScreen:) name:UIKeyboardWillHideNotification object:nil];
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
                         [self.tableView setContentOffset:offset animated:YES];
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
    [_mTextField resignFirstResponder];
    
    [[WSManager sharedInstance] addMessage:self.mChat message:self.mTextField.text completion:^(NSError *error) {
        [self updateData];
        [self.mTextField setText:nil];
    }];
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_mTextField resignFirstResponder];
}*/



-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message* message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    int date = 60*10;
    if(indexPath.row > 0)
    {
        Message* messageBefore = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
        date = message.date.timeIntervalSince1970 - messageBefore.date.timeIntervalSince1970;
    }
    
    if([message.owner.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width  - 28 ,1000);
        CGSize expectedLabelSize = [message.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        if(date >= (60*10))
        {
            return 16+expectedLabelSize.height +40;
        }
        else
        {
            return 16+expectedLabelSize.height;
        }
    }
    else
    {
        CGSize maximumLabelSize = CGSizeMake(tableView.frame.size.width  - 36-8-28 ,1000);
        CGSize expectedLabelSize = [message.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
        
        
        if(date >= (60*10))
        {
            return 46+expectedLabelSize.height +40;
        }
        else
        {
            return 46+expectedLabelSize.height;
        }
    }
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Message* lMessage = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(![lMessage.owner.identifier isEqualToString:[ShareAppContext sharedInstance].userIdentifier])
    {
        BaseViewController* lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [lMain configure:lMessage.owner];
        [self.navigationController pushViewController:lMain animated:true];
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
