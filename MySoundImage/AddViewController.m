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
- (void)dealloc
{
    [_navController release];
    [super dealloc];
}



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
   
    self.title = @"New";
    
    // Configure the save button.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Configure the cancel button.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [saveButton release];
    [cancelButton release];
    
   
    [self setUpUndoManager];
    self.editing = YES;
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self cleanUpUndoManager];    
}



@end
