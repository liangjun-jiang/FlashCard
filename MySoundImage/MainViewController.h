//
//  MainViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

//#import "FlipsideViewController.h"
#import "FlipsideNavViewController.h"

#import <CoreData/CoreData.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <CoreAudio/CoreAudioTypes.h>

@class FlipsideViewController;
@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate, FlipsideNavViewControllerDelegate,  UIAlertViewDelegate,AVAudioPlayerDelegate> {
    NSFetchedResultsController *fetchedResultController;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;

}


- (IBAction)showInfo:(id)sender;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSFetchedResultsController *fetchResultController;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (assign, nonatomic) BOOL alertInProgress;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) int index;
@property (nonatomic, retain) NSMutableArray  *imagesArray; 
@property (nonatomic, retain) NSMutableArray *soundArray;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) IBOutlet FlipsideViewController *flipsideViewController;
@property (nonatomic, retain) IBOutlet FlipsideNavViewController *flipsideNavViewController;

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void) handleSwipe:(UISwipeGestureRecognizer *)sender;
-(void) handleLongPress:(UILongPressGestureRecognizer *)sender;
-(void) handleTap:(UITapGestureRecognizer *)sender;
-(void) play:(int)index;
-(void) dataTest;

@end
