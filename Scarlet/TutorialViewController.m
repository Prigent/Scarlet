//
//  TutorialViewController.m
//  Scarlet
//
//  Created by Prigent ROUDAUT on 01/07/2016.
//  Copyright © 2016 Prigent ROUDAUT. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer * lGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pop:)];
    lGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:lGestureRight];
    
    if(self.view.tag == 1)
    {
        UISwipeGestureRecognizer * lGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
        lGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:lGestureLeft];
    }
    else
    {
        UISwipeGestureRecognizer * lGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(next)];
        lGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:lGestureLeft];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) next
{
    [self performSegueWithIdentifier:@"next" sender:self];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
    }];
}
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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
