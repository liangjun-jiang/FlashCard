//
//  FlipsideNavViewController.h
//  utitliTest
//
//  Created by Liangjun Jiang on 4/29/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddViewController.h"


@protocol FlipsideNavViewControllerDelegate;

@interface FlipsideNavViewController : UITableViewController <NSFetchedResultsControllerDelegate,AddViewControllerDelegate> {
    UINavigationController *navController;
    
    NSFetchedResultsController *fetchedResultController;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;
}



@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) id <FlipsideNavViewControllerDelegate> delegate;
@property (nonatomic,retain) UINavigationController *navController;

- (IBAction)done:(id)sender;
- (IBAction)add:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)dataTest;

@end

@protocol FlipsideNavViewControllerDelegate
- (void)flipsideNavViewControllerDidFinish:(FlipsideNavViewController *)controller;
@end