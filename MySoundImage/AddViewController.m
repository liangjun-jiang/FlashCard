//
//  AddViewController.m
//  MySoundImage
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.


//

#import "AddViewController.h"
#import "SoundImage.h"

@implementation AddViewController
@synthesize delegate;
@synthesize navController=_navController;



- (IBAction)cancel:(id)sender
{
    [delegate addViewController:self didFinishWithSave:NO];
    
}
- (IBAction)save:(id)sender
{
    [delegate addViewController:self didFinishWithSave:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = NSLocalizedString(@"NEW", @"");
    
    // Configure the save button.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Configure the cancel button.
    //UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    //self.navigationItem.leftBarButtonItem = cancelButton;
    //self.navigationItem.leftBarButtonItem.enabled = NO;
    //[cancelButton release];
    
    self.editing = YES;
    [self setUpUndoManager];
   
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self cleanUpUndoManager];    
}



@end
