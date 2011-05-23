//
//  DetailViewController.h
//  MySoundImage
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.

//

#import <UIKit/UIKit.h>


@class SoundImage, EditingViewControler;
@interface DetailViewController : UIViewController {
    SoundImage *soundImage;
    NSUndoManager *undoManager;
   
}

@property (nonatomic, retain) SoundImage *soundImage;
@property (nonatomic, retain) NSUndoManager *undoManager;
@property (nonatomic, retain) IBOutlet UITableView *tableView;


-(void)setUpUndoManager;
-(void)cleanUpUndoManager;
-(void)updateRightBarButtonItemState;
@end
