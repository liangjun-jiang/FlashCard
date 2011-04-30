//
//  PhotoViewController.m
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/28/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import "PhotoViewController.h"
#import "SoundImage.h"


@implementation PhotoViewController
@synthesize soundImage, imageView;

- (void)loadView {
	self.title = @"Photo";
    
    imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor blackColor];
    
    self.view = imageView;
}


- (void)viewWillAppear:(BOOL)animated {
    imageView.image = [soundImage.imagePath valueForKey:@"image"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)dealloc {
    [imageView release];
    [soundImage release];
    [super dealloc];
}
@end
