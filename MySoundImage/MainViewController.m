//
//  MainViewController.m
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import "MainViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation MainViewController

@synthesize managedObjectContext=_managedObjectContext;
@synthesize fetchResultController,addingManagedObjectContext;
@synthesize flipsideViewController=_flipsideViewController;
@synthesize flipsideNavViewController=_flipsideNavViewController;

@synthesize alertInProgress=_alertInProgress;
@synthesize imageView=_imageView;
@synthesize index=_index;
@synthesize imagesArray=_imagesArray,soundArray=_soundArray, audioPlayer=_audioPlayer;


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    self.alertInProgress = NO;
}


-(void) handleLongPress:(UILongPressGestureRecognizer *)sender{
    if (!self.alertInProgress){
        self.alertInProgress = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"this is not fun." delegate:self cancelButtonTitle:@"Fine." otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

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

-(void) handleTap:(UITapGestureRecognizer *)sender{
    [self.audioPlayer stop];
    self.index = arc4random() % [self.imagesArray count];
    [self play:self.index];
    self.imageView.image = [UIImage imageWithContentsOfFile:[self.imagesArray objectAtIndex:self.index]];
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
    
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
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


/*
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}
*/

- (void)flipsideNavViewControllerDidFinish:(FlipsideNavViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender
{    
    //FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    FlipsideNavViewController *controller = [[FlipsideNavViewController alloc] initWithNibName:@"FlipsideNavView" bundle:nil];
    
    controller.delegate = self;
   
    controller.managedObjectContext = self.managedObjectContext;
    
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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
    [_flipsideViewController release];
    [_flipsideNavViewController release];
    [_imageView release];
    [_imagesArray release];
    [_audioPlayer release];
    [_managedObjectContext release];
    [super dealloc];
}

- (void)play:(int)index
{
    //NSString *filePath = [[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, [self.soundArray objectAtIndex:index]] retain];
    
    NSURL *url = [NSURL fileURLWithPath: [self.soundArray objectAtIndex:index]];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    if(!audioData)
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    [self.audioPlayer release];
    
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

@end
