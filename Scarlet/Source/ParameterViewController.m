//
//  ParameterViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "ParameterViewController.h"
#import "WSParser.h"
#import "ShareAppContext.h"
#import "WSManager.h"
@interface ParameterViewController ()

@end

@implementation ParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mCustomTitle = NSLocalizedString(@"settings",nil);//@"Settings";
    // Do any additional setup after loading the view.
    
    [[WSManager sharedInstance] getNotificationConfiguration:^(NSError *error) {
        [self.mTableView reloadData];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}





-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:false animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ShareAppContext sharedInstance].notificationDic allKeys] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"notifications", nil);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSString * lKey = [[[ShareAppContext sharedInstance].notificationDic allKeys] objectAtIndex:indexPath.row];
    
    NSNumber * lValue = [[[ShareAppContext sharedInstance].notificationDic allValues] objectAtIndex:indexPath.row];
    lValue = [NSNumber numberWithBool:![lValue boolValue]];

    
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications])
    {
        UIAlertView * lUIAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"no_push_configuration", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel",nil) otherButtonTitles:NSLocalizedString(@"configure",nil), nil];
        lUIAlertView.tag = 1;
        [lUIAlertView show];
    }
    else
    {
        [[WSManager sharedInstance] setNotificationConfiguration:lKey andValue:lValue completion:^(NSError *error) {
            [self.mTableView reloadData];
        }];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    if([cell respondsToSelector:@selector(configure:)])
    {
        [cell performSelector:@selector(configure:) withObject:@[[[[ShareAppContext sharedInstance].notificationDic allKeys] objectAtIndex:indexPath.row],[[[ShareAppContext sharedInstance].notificationDic allValues] objectAtIndex:indexPath.row] ]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 0, tableView.frame.size.width-16, 34);
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
        return 34;
    }
    
    return 8;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)disconnect:(id)sender {
    [[ShareAppContext sharedInstance] setAccessToken:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnect" object:nil];
}


@end
