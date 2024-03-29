//
//  MainViewController.h
//  MySoundImage
//
//  Main view is to show images, play sound and 
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.


//

//#import "FlipsideViewController.h"
#import "FlipsideNavViewController.h"

#import <CoreData/CoreData.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate, FlipsideNavViewControllerDelegate,  UIAlertViewDelegate,AVAudioPlayerDelegate> {
    NSFetchedResultsController *fetchedResultController;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *addingManagedObjectContext;

}


- (IBAction)showInfo:(id)sender;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *fetchResultController;
@property (nonatomic, strong) NSManagedObjectContext *addingManagedObjectContext;
@property (assign, nonatomic) BOOL alertInProgress;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) int index;
@property (nonatomic, strong) NSMutableArray  *imagesArray; 
@property (nonatomic, strong) NSMutableArray *soundArray;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) IBOutlet FlipsideNavViewController *flipsideNavViewController;

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
-(void) handleSwipe:(UISwipeGestureRecognizer *)sender;
-(void) handleLongPress:(UILongPressGestureRecognizer *)sender;
-(void) handleTap:(UITapGestureRecognizer *)sender;
-(void) play:(int)index;
-(UIImage *)scaleAndRotateImage:(UIImage *)image;
-(void) dataTest;

@end
