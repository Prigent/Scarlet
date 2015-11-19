//
//  BaseTabViewController.m
//  OM
//
//  Created by Prigent ROUDAUT on 07/11/2014.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import "BaseTabViewController.h"

@interface BaseTabViewController ()

@end

@implementation BaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    for(UIViewController* lViewController in self.viewControllers)
    {
        UIViewController* lNext = lViewController;
        if([lNext isKindOfClass:[UINavigationController class]])
        {
            lNext =  [(UINavigationController*)lNext topViewController];
        }
        if([lNext respondsToSelector:@selector(configure:)])
        {
            [lNext performSelector:@selector(configure:) withObject:self.mObject];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configure:(NSObject*) object
{
    self.mObject = object;
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [super setViewControllers:viewControllers animated:animated];
    for(UIViewController* lViewController in viewControllers)
    {
        UIViewController* lNext = lViewController;
        if([lNext isKindOfClass:[UINavigationController class]])
        {
            lNext =  [(UINavigationController*)lNext topViewController];
        }
        if([lNext respondsToSelector:@selector(configure:)])
        {
            [lNext performSelector:@selector(configure:) withObject:self.mObject];
        }
    }
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
