//
//  CreateEventViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 26/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "CreateEventViewController.h"
#import "WSParser.h"
#import "ProfileListCell.h"
#import "WSManager.h"
#import "MBProgressHUD.h"
#import "FieldEventCell.h"
#import "ShareAppContext.h"
#import "Profile.h"
#import "User.h"
#import "FriendViewController.h"
#import "Event.h"
#import "Address.h"
#import "AppDelegate.h"
#import "Toast+UIView.h"

@interface CreateEventViewController ()

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profilelistselected:) name:@"profilelistselected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moodChanged:) name:@"moodChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChanged:) name:@"dateChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged:) name:@"locationChanged" object:nil];
    
   
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    

    
    if(self.mEvent)
    {
        [self editInit];
        [self.mButton setTitle:NSLocalizedString2(@"save_scarlet", nil) forState:UIControlStateNormal];
        self.screenName = @"edit_event";
    }
    else
    {
        [self createInit];
        self.screenName = @"create_event";
    }
}

-(void) editInit
{
    self.date = self.mEvent.date;

    self.listProfileId = [NSMutableArray array];
    
    for(Profile* lProfile in self.mEvent.partners)
    {
        [self.listProfileId addObject:lProfile.identifier];
    }
    
    self.mood =self.mEvent.mood;

    self.address = self.mEvent.address.street;

    self.coordinate =CLLocationCoordinate2DMake([self.mEvent.address.lat floatValue], [self.mEvent.address.longi floatValue]);
    self.title = NSLocalizedString2(@"edit_scarlet", nil);

}

-(void) createInit
{
    self.date = [NSDate date];
    self.listProfileId = [NSMutableArray array];
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Mood" ofType:@"plist"];
    NSString * lMood = [[[NSArray alloc] initWithContentsOfFile:plistFile] firstObject];
    self.mood = NSLocalizedString2(lMood,lMood);
    
    
    CLPlacemark* lCLPlacemark = [ShareAppContext sharedInstance].placemark;
    self.coordinate = CLLocationCoordinate2DMake(lCLPlacemark.location.coordinate.latitude,lCLPlacemark.location.coordinate.longitude);
    NSString *locatedAt = [[lCLPlacemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    if(locatedAt != nil)
    {
        self.address = [[NSString alloc]initWithString:locatedAt];
    }
    else
    {
        self.address = NSLocalizedString2(@"no_address", nil);
    }

    
    self.title = NSLocalizedString2(@"new_scarlet", nil);
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mTableView reloadData];
}

-(void) configure:(id)event
{
    self.mEvent = event;
}

-(void) popBack {

    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createEvent:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString2(@"loading", nil);
    

    
    NSMutableDictionary * lEventDic = [NSMutableDictionary dictionary];

    [lEventDic setValue:self.mood forKey:@"mood"];
    [lEventDic setValue:[NSNumber numberWithDouble:self.coordinate.longitude]  forKey:@"long"];
    [lEventDic setValue:[NSNumber numberWithDouble:self.coordinate.latitude] forKey:@"lat"];
    [lEventDic setValue:self.address forKey:@"address"];
    [lEventDic setValue:[NSNumber numberWithInt:[self.date timeIntervalSince1970]] forKey:@"date"];
    [lEventDic setValue:self.listProfileId forKey:@"partner"];
    

    
    if(self.mEvent)
    {
        [lEventDic setValue:self.mEvent.identifier forKey:@"event_identifier"];

        NSLog(@"%@",lEventDic);
        
        NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"create_event"  label:nil value:nil] build];
        [[[GAI sharedInstance] defaultTracker]  send:event];
        
        [[WSManager sharedInstance] editEvent:lEventDic completion:^(NSError *error) {
            
            [hud hide:YES];
            if(error == nil)
            {
                [self popBack];
            }
            else
            {
                NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
                NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
                [[[UIAlertView alloc] initWithTitle:nil message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
    else
    {
        NSMutableDictionary *  event = [[GAIDictionaryBuilder createEventWithCategory:@"ui_action"   action:@"edit_event"  label:nil value:nil] build];
        [[[GAI sharedInstance] defaultTracker]  send:event];
        
        [[WSManager sharedInstance] createEvent:lEventDic completion:^(NSError *error) {
            
            [hud hide:YES];
            if(error == nil)
            {
                [[AppDelegate topMostController].tabBarController setSelectedIndex:1];
                [[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]  makeButtonToast:NSLocalizedString2(@"toast_didpublish", nil)];
                [self popBack];
            }
            else
            {
                NSString * lErrorKey  = [NSString stringWithFormat:@"servor_error_%d",abs((int)error.code)];
                NSString * lErrorString = NSLocalizedString2( lErrorKey, nil);
                [[[UIAlertView alloc] initWithTitle:@"" message:lErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
        }];
    }

}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 3;
    }
    if([[ShareAppContext sharedInstance].user.friends count]>0)
    {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 44;
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        return 165;
    }
    return 64;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0) return 1;
    return 16;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(  indexPath.section == 0)
    {
        return true;
    }
    return false;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(  indexPath.section == 0)
    {
        BaseViewController* lMain = nil;
        switch (indexPath.row) {
            case 0:
                lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"DateViewController"];
                [lMain configure:self.date];
                break;
            case 1:
                lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearchViewController"];
                [lMain configure:nil];
                break;
            case 2:
                lMain =  [self.storyboard instantiateViewControllerWithIdentifier:@"MoodViewController"];
                [lMain configure:self.mood];
                break;
            default:break;
        }
        
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:lMain animated:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if(indexPath.section == 0)
    {
        FieldEventCell * cellField = [tableView dequeueReusableCellWithIdentifier:@"FieldEventCell"];
        switch (indexPath.row) {
            case 0:
            {
                cellField.mIcn.image =[UIImage imageNamed:@"icnCalendar"];
                NSString* datePart = [NSDateFormatter localizedStringFromDate: self.date dateStyle: kCFDateFormatterMediumStyle timeStyle: NSDateFormatterShortStyle];
                cellField.mTitle.text = [datePart capitalizedString];
            }
            break;
            case 1:
            {
                cellField.mIcn.image =[UIImage imageNamed:@"icnMapProfil"];
                cellField.mTitle.text = self.address;
            }
            break;
            case 2:
            {
                cellField.mIcn.image =[UIImage imageNamed:@"icnMood"];
                cellField.mTitle.text = self.mood;
            }
            break;
            default:break;
        }
        return cellField;
        
        
        
    }
    else if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
        ProfileListCell* cellList = (ProfileListCell*)cell;
        [cellList configure:[[ShareAppContext sharedInstance].user.friends array] andSelectedList:self.listProfileId];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddMoreFriend"];
    }
    return cell;
}

- (IBAction)inviteFriend:(id)sender {
    FriendViewController *viewController = nil;
    viewController = [[UIStoryboard storyboardWithName:@"Friend" bundle:nil] instantiateInitialViewController];
    viewController.type = 2;
    viewController.hidesBottomBarWhenPushed = YES;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    
    
    [self.navigationController pushViewController:viewController animated:false];
}


-(void) moodChanged:(NSNotification*) notification
{
    self.mood = notification.object;
}

-(void) dateChanged:(NSNotification*) notification
{
    self.date = notification.object;
}

-(void) locationChanged:(NSNotification*) notification
{
    CLPlacemark* lLocation = [notification object];
    NSString *locatedAt = [[lLocation.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    if(locatedAt != nil)
    {
        self.address = [[NSString alloc]initWithString:locatedAt];
    }
    else
    {
        self.address =  NSLocalizedString2(@"no_address", nil);
    }
    self.coordinate = lLocation.location.coordinate;
    
}


-(void) profilelistselected:(NSNotification*) notification
{
    id data = [notification object];
    
    if([data isKindOfClass: [Profile class]])
    {
        Profile * profile = (Profile*)data;
        if([self.listProfileId containsObject:profile.identifier])
        {
            [self.listProfileId removeObject:profile.identifier];
        }
        else
        {
            [self.listProfileId addObject:profile.identifier];
        }
        [self.mTableView reloadData];
    }
}
@end
