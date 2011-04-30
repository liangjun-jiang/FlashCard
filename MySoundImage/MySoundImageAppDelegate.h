//
//  MySoundImageAppDelegate.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"

@class MainViewController;

@interface MySoundImageAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)createEditableCopyOfDatabaseIfNeeded;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
