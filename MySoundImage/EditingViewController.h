//
//  EditingViewController.h
//  MySoundImage
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.


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
    
    BOOL editing;
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
    
    //UIBarButtonItem
    UIBarButtonItem *saveButton;
    UIBarButtonItem *cancelButton;
    
}

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSManagedObject *editedObject;
@property (nonatomic, strong) NSString *editedFieldKey;
@property (nonatomic, strong) NSString *editedFieldName;
@property (nonatomic, assign, getter=isEditingImage) BOOL editingImage;
@property (nonatomic, assign, getter=isEditingSound) BOOL editingSound;
@property (nonatomic, assign, getter=isEditingVoice) BOOL editingVoice;
@property (nonatomic, assign, getter=isEditingTitle) BOOL editingTitle;

@property (nonatomic, strong) IBOutlet UIPickerView *soundPicker;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIButton *stopButton;
@property (nonatomic, strong) IBOutlet UIButton *stopPlayerButton;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;

@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
//@property (nonatomic, retain) NSString *placeHolder;


@property (nonatomic, strong) NSMutableArray *sounds;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (IBAction) cancel;
- (IBAction) save;
- (IBAction) photoTapped;
- (IBAction) record:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) play:(id)sender;
- (IBAction) stopPlayer:(id)sender;

- (void) initRecorder;
//- (NSMutableArray *)obtainAllSounds;
- (NSString *) pathBuilder;
- (NSString *) fileNameBuilder;


@end
