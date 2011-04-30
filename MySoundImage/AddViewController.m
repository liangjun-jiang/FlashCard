//
//  AddViewController.m
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import "AddViewController.h"
#import "SoundImage.h"

@implementation AddViewController
@synthesize delegate;

- (void)dealloc
{
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
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] autorelease];
    [self setUpUndoManager];
    self.editing = YES;
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self cleanUpUndoManager];    
}



@end
