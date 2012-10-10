//
//  MainViewController.m
//  MySoundImage
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.

//

#import "MainViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation MainViewController

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchResultController,addingManagedObjectContext;
@synthesize flipsideNavViewController=_flipsideNavViewController;

@synthesize alertInProgress=_alertInProgress;
@synthesize imageView=_imageView;
@synthesize index=_index;
@synthesize imagesArray=_imagesArray,soundArray=_soundArray, audioPlayer=_audioPlayer;


// alert
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.alertInProgress = NO;
}


// handle long press
-(void) handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (!self.alertInProgress){
        self.alertInProgress = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"")  message:NSLocalizedString(@"NOFUN", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"FINE", @"") otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

// handle swipe
-(void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    
    [self.audioPlayer stop];
    
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];	
    switch (direction){
        case UISwipeGestureRecognizerDirectionUp:
        case UISwipeGestureRecognizerDirectionDown:
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            self.index = (self.index + 1) %[self.imagesArray count];
            [self play:self.index];
            break;
        }
        case UISwipeGestureRecognizerDirectionRight:
        {
            self.index = (self.index + [self.imagesArray count] - 1) %[self.imagesArray count];
            [self play:self.index];
            break;
        }
    }
    self.imageView.image = [UIImage imageWithContentsOfFile:[self.imagesArray objectAtIndex:self.index]];
}


// handle tap
-(void) handleTap:(UITapGestureRecognizer *)sender{
    [self.audioPlayer stop];
    self.index = arc4random() % [self.imagesArray count];
    [self play:self.index];
    UIImage *tempImage = [[UIImage alloc] initWithContentsOfFile:[self.imagesArray objectAtIndex:self.index]];
    self.imageView.image = tempImage;//[self scaleAndRotateImage:tempImage];
    
    [tempImage release];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.alertInProgress = NO;
    
    self.imagesArray = [[NSMutableArray alloc] init];
    self.soundArray = [[NSMutableArray alloc] init];
    
    self.index = 0;
    
    //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.backgroundColor = [UIColor blackColor];
   
    
    [self.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];	
    [self.imageView addGestureRecognizer:longpressGesture];
    [longpressGesture release];
    
    //Listen to the left and right swipe
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    //left
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self dataTest];
}


- (void)flipsideNavViewControllerDidFinish:(FlipsideNavViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

// hanlde info

- (IBAction)showInfo:(id)sender
{    
    FlipsideNavViewController *controller = [[FlipsideNavViewController alloc] initWithNibName:@"FlipsideNavView" bundle:nil];
    
    controller.delegate = self;
   
    controller.managedObjectContext = self.managedObjectContext;
    controller.addingManagedObjectContext = self.managedObjectContext;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
    
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    controller.navController = navController;
    navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
   
    [self presentModalViewController:controller animated:YES];
    
    
    [navController release];
    [controller release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imagesArray = nil;
    self.imageView = nil;
    self.audioPlayer = nil;

    
}

- (void)dealloc
{
    [_flipsideNavViewController release];
    [_imageView release];
    [_imagesArray release];
    [_audioPlayer release];
    [_managedObjectContext release];
    [super dealloc];
}

- (void)play:(int)index
{
    NSURL *url = [NSURL fileURLWithPath: [self.soundArray objectAtIndex:index]];
    NSError *err = nil;
    if (url != nil){
        NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
        if(!audioData)
            NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
        [self.audioPlayer release];
    }
    
}


- (void) dataTest {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    // iterate over soundImage
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"SoundImage" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        
        // output course's title
        if ([info valueForKey:@"name"] !=nil && [info valueForKey:@"imagePath"] !=nil && [info valueForKey:@"soundPath"] !=nil)
        {
        [self.imagesArray addObject:[NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER,[info valueForKey:@"imagePath"]]];
        [self.soundArray addObject:[NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER,[info valueForKey:@"soundPath"]]];
        }
        /*
        // iterate over students
        NSSet *students = [info valueForKey:@"students"];
        for (NSManagedObject *student in students) {
            
            // output student's name and concentration
            NSLog(@"- %@ (%@)", [student valueForKey:@"name"], [student valueForKey:@"concentration"]);
        }
         */
    }     
    //NSLog(@"Images: %@", self.imagesArray);
    [fetchRequest release];
    
}


// todo 
//this part code is from http://blog.logichigh.com/2008/06/05/uiimage-fix/

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
	int kMaxResolution = 320; // Or whatever
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}


@end
