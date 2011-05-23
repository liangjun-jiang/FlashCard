//
//  MySoundImageAppDelegate.h
//
// main delegate class
//
//  MySoundImage
//
/// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.

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
