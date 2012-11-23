//
//  AddViewController.h
//  MySoundImage
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.

//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@protocol AddViewControllerDelegate;


@interface AddViewController : DetailViewController {
    id<AddViewControllerDelegate> delegate;
    
}

@property (nonatomic, strong) id <AddViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UINavigationController *navController;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

@protocol AddViewControllerDelegate
-(void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save;
@end