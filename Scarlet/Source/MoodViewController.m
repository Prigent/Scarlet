//
//  MoodViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 25/11/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import "MoodViewController.h"

@interface MoodViewController ()

@end

@implementation MoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString2(@"select_mood",nil);
    
    // Do any additional setup after loading the view.
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 25.0f, 25.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"btnClose"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25.0f, 0, 25.0f)];
    [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    
    NSString *plistFile = [[NSBundle mainBundle] pathForResource:@"Mood" ofType:@"plist"];
    self.mData = [NSMutableArray array];
    NSArray * lData = [[NSArray alloc] initWithContentsOfFile:plistFile];
    for(NSString * lMood in lData)
    {
        [self.mData addObject:NSLocalizedString2(lMood, lMood)];
    }




    if(self.filter)
    {
        [self.mData insertObject:NSLocalizedString2(@"whatever",nil) atIndex:0];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString2(@"save",nil) style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.screenName = @"select_mood";
}


-(void) save {
    
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
-(void) configure:(id)mood
{
    self.mMood = mood;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MoodCell"];
    cell.textLabel.text = [self.mData objectAtIndex:indexPath.row];
    
    if([cell.textLabel.text isEqualToString:self.mMood])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if([self.mMood isEqualToString:[self.mData objectAtIndex:indexPath.row]])
    {
        if(self.filter)
        {
            self.mMood = nil;
        }
    }
    else
    {
        self.mMood = [self.mData objectAtIndex:indexPath.row];
    }

    
    if(self.filter)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moodFilterChanged" object:self.mMood];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moodChanged" object:self.mMood];
    }
    

    [tableView reloadData];
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
