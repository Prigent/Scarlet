//
//  AutoListViewController.h
//  Template
//
//  Created by Prigent ROUDAUT on 22/10/2014.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AutoListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    NSInteger currentIndex;
}

-(void) configure:(NSDictionary*) dic;
-(void) updatePredicate:(NSString*) predicateValue;
-(void) updateWithPredicate:(NSPredicate*) predicate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *emptyStateView;
@property (weak, nonatomic) IBOutlet UIView *emptyStateView2;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString* entityName;
@property (strong, nonatomic) NSString* sortProperty;
@property (strong, nonatomic) NSNumber* sortOrder;
@property (strong, nonatomic) NSNumber* sortOrder2;
@property (strong, nonatomic) NSString* predicateProperty;
@property (strong, nonatomic) NSString* sectionKeyProperty;
@property (strong, nonatomic) NSString* cellIdentifier;
@property (strong, nonatomic) NSString* sectionIdentifier;
@property (strong, nonatomic) NSString* detailIdentifier;
@property (strong, nonatomic) NSString* showIdentifier;
@property (strong, nonatomic) NSDictionary* dicBase;
@property (strong, nonatomic) UIRefreshControl* uiRefreshControl;

@end
