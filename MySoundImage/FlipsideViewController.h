//
//  FlipsideViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddViewController.h"

//@class FlipsideRootViewController;

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <NSFetchedResultsControllerDelegate,AddViewControllerDelegate>{
    NSFetchedResultsController *fetchedResultController;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


- (IBAction)done:(id)sender;
- (IBAction)add:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)dataTest;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end


