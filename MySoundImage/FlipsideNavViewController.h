//
//  FlipsideNavViewController.h
//  
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.


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



@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, unsafe_unretained) id <FlipsideNavViewControllerDelegate> delegate;
@property (nonatomic,strong) UINavigationController *navController;

- (IBAction)done:(id)sender;
- (IBAction)add:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//- (void)dataTest;

@end

@protocol FlipsideNavViewControllerDelegate
- (void)flipsideNavViewControllerDidFinish:(FlipsideNavViewController *)controller;
@end
