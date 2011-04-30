//
//  EditingViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <CoreAudio/CoreAudioTypes.h>


@interface EditingViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>{
    UITextField *textField;
    NSManagedObject *editedObject;
    NSString *editedFieldKey;
    NSString *editedFieldName;
    BOOL editingImage;
    BOOL editingTitle;
    
    BOOL editingSound;
    BOOL editingVoice;
    UIPickerView *soundPicker;
    UIButton *photoButton;
    UIButton *recordButton;
    
    UIButton *playButton;
    UIButton *stopButton;
    UIButton *stopPlayerButton;
    
    UILabel *statusLabel;
    
    NSMutableArray *sounds;
    
    AVAudioRecorder *recorder;
    AVAudioPlayer *audioPlayer;
    UIImageView *photoImageView;
    
}

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, retain) NSManagedObject *editedObject;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, retain) NSString *editedFieldName;
@property (nonatomic, assign, getter=isEditingImage) BOOL editingImage;
@property (nonatomic, assign, getter=isEditingSound) BOOL editingSound;
@property (nonatomic, assign, getter=isEditingVoice) BOOL editingVoice;
@property (nonatomic, assign, getter=isEditingTitle) BOOL editingTitle;

@property (nonatomic, retain) IBOutlet UIPickerView *soundPicker;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *stopPlayerButton;
@property (nonatomic, retain) IBOutlet UIImageView *photoImageView;
//@property (nonatomic, retain) NSString *placeHolder;


@property (nonatomic, retain) NSMutableArray *sounds;

@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

- (IBAction) cancel;
- (IBAction) save;
- (IBAction) photoTapped;
- (IBAction) record:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) play:(id)sender;
- (IBAction) stopPlayer:(id)sender;

- (void) initRecorder;
- (NSMutableArray *)initSounds;
- (NSString *) pathBuilder;
- (NSString *) fileNameBuilder;


@end