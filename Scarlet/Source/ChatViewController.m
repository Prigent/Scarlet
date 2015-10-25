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
    
    
    [[WSManager sharedInstance] getMessagesForChat:self.mChat completion:^(NSError *error) {
    }];
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}

-(void) configure:(Chat*) chat
{
    self.mChat = chat;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    Message* lMessage = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
   
    
    BaseViewController* lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    [lMain configure:lMessage.owner];
    [self.navigationController pushViewController:lMain animated:true];
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
