//
//  DetailViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SoundImage, EditingViewControler;
@interface DetailViewController : UIViewController {
    SoundImage *soundImage;
    NSDateFormatter *dateFormatter;
    NSUndoManager *undoManager;
}

@property (nonatomic, retain) SoundImage *soundImage;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSUndoManager *undoManager;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(void)setUpUndoManager;
-(void)cleanUpUndoManager;
-(void)updateRightBarButtonItemState;
@end
