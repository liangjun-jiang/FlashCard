//
//  MainViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {

}


- (IBAction)showInfo:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
