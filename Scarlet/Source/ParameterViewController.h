//
//  ParameterViewController.h
//  Scarlet
//
//  Created by Prigent ROUDAUT on 22/10/2015.
//  Copyright © 2015 Prigent ROUDAUT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ParameterViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
