//
//  AutoListViewController.m
//  Template
//
//  Created by Prigent ROUDAUT on 22/10/2014.
//  Copyright (c) 2014 HighConnexion. All rights reserved.
//

#import "AutoListViewController.h"
#import "AppDelegate.h"

@interface AutoListViewController ()

@end

@implementation AutoListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     NSError *error = nil;
    
    self.uiRefreshControl = [[UIRefreshControl alloc] init];
    self.uiRefreshControl.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    self.uiRefreshControl.tintColor = [UIColor colorWithRed:1 green:29/255. blue:76/255. alpha:1];
    [self.uiRefreshControl addTarget:self  action:@selector(updateData)   forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.uiRefreshControl];
    
    
    [[self fetchedResultsController] performFetch:&error];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }

    if([_showIdentifier length]>0)
    {
        [self performSegueWithIdentifier:_showIdentifier sender:self];
    }
}

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.objectToPush = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return indexPath;
}

-(void) updateData
{
    NSLog(@"NOT OK");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    if(self.entityName == nil)
    {
        return nil;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
   // [NSFetchedResultsController deleteCacheWithName:self.cellIdentifier];

    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    
    if(self.predicateProperty !=nil && [self.predicateProperty length]>0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:self.predicateProperty];
        [fetchRequest setPredicate:predicate];
    }

    if(self.sortProperty !=nil && [self.sortProperty length]>0)
    {
        NSArray* lSortProperties = [self.sortProperty componentsSeparatedByString:@"&"];
        NSMutableArray* sortDescriptors = [NSMutableArray array];
        for (int i=0; i<[lSortProperties count]; i++)
        {
            NSString* lSortProperty = [lSortProperties objectAtIndex:i];
            if(i==0)
            {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:lSortProperty ascending:[self.sortOrder boolValue]];
                [sortDescriptors addObject:sortDescriptor];
            }
            else
            {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:lSortProperty ascending:[self.sortOrder2 boolValue]];
                [sortDescriptors addObject:sortDescriptor];
            }
        }

        [fetchRequest setSortDescriptors:sortDescriptors];
    }

    
    NSString* sectionKey = nil;
    if(self.sectionKeyProperty !=nil && [self.sectionKeyProperty length]>0)
    {
        sectionKey = self.sectionKeyProperty;
    }
   
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:sectionKey cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
    
    
    return _fetchedResultsController;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default: break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
           // [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) configure:(NSDictionary*) dic
{
    if([dic isKindOfClass:[NSDictionary class]])
    {
        [super configure:dic];
        self.dicBase = dic;
        self.entityName = [dic valueForKey:@"entityName"];
        self.sortProperty = [dic valueForKey:@"sortProperty"];
        self.predicateProperty = [dic valueForKey:@"predicateProperty"];
        self.sectionKeyProperty = [dic valueForKey:@"sectionKeyProperty"];
        self.cellIdentifier = [dic valueForKey:@"cellIdentifier"];
        self.sectionIdentifier =  [dic valueForKey:@"sectionIdentifier"];
        self.showIdentifier = [dic valueForKey:@"showIdentifier"];
        self.detailIdentifier = [dic valueForKey:@"detailIdentifier"];
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad  && [dic valueForKey:@"cellIdentifierIpad"]!=nil )
        {
             self.cellIdentifier = [dic valueForKey:@"cellIdentifierIpad"];
        }
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad  && [dic valueForKey:@"sectionIdentifierIpad"]!=nil )
        {
            self.sectionIdentifier = [dic valueForKey:@"sectionIdentifierIpad"];
        }
        if([dic valueForKey:@"sortOrder"])
        {
            self.sortOrder = [dic valueForKey:@"sortOrder"];
        }
        else
        {
            self.sortOrder = [NSNumber numberWithBool:true];
        }
        if([dic valueForKey:@"sortOrder2"])
        {
            self.sortOrder2 = [dic valueForKey:@"sortOrder2"];
        }
        else
        {
            self.sortOrder2 = [NSNumber numberWithBool:true];
        } 
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    NSObject* obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if([cell respondsToSelector:@selector(configure:)])
    {
        [cell performSelector:@selector(configure:) withObject:obj];
    }
    
    return cell;
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSInteger count = [sectionInfo numberOfObjects];
    
    self.emptyStateView.hidden = (count != 0);
    
    return count;
}

-(void) updatePredicate:(NSString*) predicateValue
{
    self.predicateProperty = predicateValue;
    //[NSFetchedResultsController deleteCacheWithName:self.cellIdentifier];
    if(self.predicateProperty  !=nil && [self.predicateProperty length]>0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateValue];
        [[self fetchedResultsController].fetchRequest setPredicate:predicate];
    }
    else
    {
        [[self fetchedResultsController].fetchRequest setPredicate:nil];
    }
    
    NSError *error = nil;

    
    if (![self.fetchedResultsController performFetch:&error]) {
        
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        
        
        
    }
    [self.tableView reloadData];

}


-(void) updateWithPredicate:(NSPredicate*) predicate
{
    //[NSFetchedResultsController deleteCacheWithName:self.cellIdentifier];
    [[self fetchedResultsController].fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.sectionIdentifier == nil)
    {
        return 0;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.sectionIdentifier];
        return cell.frame.size.height;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.sectionIdentifier == nil)
    {
        return nil;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.sectionIdentifier];
        if(section < tableView.numberOfSections  && [tableView numberOfRowsInSection:section]>0)
        {
            NSObject* obj = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            if([cell respondsToSelector:@selector(configure:)])
            {
                [cell performSelector:@selector(configure:) withObject:obj];
            }
        }
        return cell.contentView;
    }
}




@end
