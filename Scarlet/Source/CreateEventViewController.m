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
    }
    else
    {
        [self createInit];
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
    self.title = @"Edit Scarlet";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(createEvent)];
    
}

-(void) createInit
{
    self.date = [NSDate date];
    self.listProfileId = [NSMutableArray array];
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Mood" ofType:@"plist"];
    self.mood = [[[NSArray alloc] initWithContentsOfFile:plistFile] objectAtIndex:0];
    
    
    
    NSString *locatedAt = [[[ShareAppContext sharedInstance].placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    if(locatedAt != nil)
    {
        self.address = [[NSString alloc]initWithString:locatedAt];
    }
    else
    {
        self.address = @"no address";
    }
    self.coordinate = [ShareAppContext sharedInstance].placemark.location.coordinate;
    self.title = @"New Scarlet";
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createEvent)];
    
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

- (void)createEvent {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    

    
    NSMutableDictionary * lEventDic = [NSMutableDictionary dictionary];

    if(self.mEvent)
    {
        [lEventDic setValue:self.mEvent.identifier forKey:@"event_identifier"];
    }
    
    [lEventDic setValue:self.mood forKey:@"mood"];
    [lEventDic setValue:[NSNumber numberWithDouble:self.coordinate.longitude]  forKey:@"long"];
    [lEventDic setValue:[NSNumber numberWithDouble:self.coordinate.latitude] forKey:@"lat"];
    [lEventDic setValue:self.address forKey:@"address"];
    [lEventDic setValue:[NSNumber numberWithInt:[self.date timeIntervalSince1970]+60] forKey:@"date"];
    [lEventDic setValue:self.listProfileId forKey:@"partner"];
    
    
    if(self.mEvent)
    {
        [[WSManager sharedInstance] editEvent:lEventDic completion:^(NSError *error) {
            
            [hud hide:YES];
            if(error == nil)
            {
                [self popBack];
            }
            else
            {
                NSLog(@"%@", error);
            }
            
        }];
    }
    else
    {
        [[WSManager sharedInstance] createEvent:lEventDic completion:^(NSError *error) {
            
            [hud hide:YES];
            if(error == nil)
            {
                [self popBack];
            }
            else
            {
                NSLog(@"%@", error);
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
                
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"EEEE dd MMMM  h:mm a"];
                
                cellField.mTitle.text = [format stringFromDate:self.date];
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
        [cellList configure:[[ShareAppContext sharedInstance].user.friends allObjects] andSelectedList:self.listProfileId];
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
        self.address = @"Default address";
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
