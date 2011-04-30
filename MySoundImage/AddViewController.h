//
//  AddViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@protocol AddViewControllerDelegate;


@interface AddViewController : DetailViewController {
    id<AddViewControllerDelegate> delegate;
}

@property (nonatomic, retain) id <AddViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddViewControllerDelegate
-(void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save;
@end