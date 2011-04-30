//
//  EditingViewController.m
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import "EditingViewController.h"
#import "PhotoViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation EditingViewController

@synthesize textField, editedObject, editedFieldKey, editedFieldName, editingTitle, editingImage, editingSound, editingVoice, soundPicker,photoButton, recordButton, sounds, statusLabel, recorder, audioPlayer, playButton, stopButton, stopPlayerButton, photoImageView;
//@synthesize placeHolder=_placeHolder;


- (void)dealloc
{
  
    [recorder release];
    [audioPlayer release];
    [sounds release];
    [statusLabel release];
    [photoButton release];
    [recordButton release];
    [playButton release];
    [stopButton release];
    [stopPlayerButton release];
    [soundPicker release];
    [textField release];
    [editedObject release];
    [editedFieldKey release];
    [editedFieldName release];
    [photoImageView release];
   
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = editedFieldName;
    
    // Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
    
    sounds = [[NSMutableArray alloc] init];
    //self.placeHolder = editedFieldName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    textField.clearButtonMode = UITextFieldViewModeAlways;   
    textField.hidden = NO;
    photoButton.hidden =YES;
    soundPicker.hidden = YES;
    recordButton.hidden = YES;
    playButton.hidden = YES;
    stopButton.hidden = YES;
    stopPlayerButton.hidden = YES;
    photoImageView.hidden = YES;
    // Configure the user interface according to state.
    
    if(editingTitle){
        textField.hidden = NO;
        textField.text = [editedObject valueForKey:editedFieldKey];
        textField.placeholder = self.title;
        [textField becomeFirstResponder];
    }
    else if(editingImage){
        textField.hidden = NO;
        textField.placeholder=@"Enter an image name";
        [textField becomeFirstResponder];
        photoButton.hidden = NO;
        /*
        photoImageView.hidden = YES;
        photoImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        photoImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        photoImageView.backgroundColor = [UIColor blackColor];
        photoImageView.image = [UIImage imageNamed:[self fileNameBuilder]];
         */
    } else if(editingSound){
        textField.placeholder=@"Your selection will be appeared here";
        textField.enabled = NO;
        [self initSounds];
        soundPicker.hidden = NO;
    } else if (editingVoice){
            
        textField.hidden = NO;
        textField.placeholder = @"Enter a voice name";
        [textField becomeFirstResponder];
        recordButton.hidden =NO;
        recordButton.enabled = NO;
        
    } else {
        soundPicker.hidden = NO;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Save and cancel operations

- (IBAction)save {
	
	// Set the action name for the undo operation.
	NSUndoManager * undoManager = [[editedObject managedObjectContext] undoManager];
	[undoManager setActionName:[NSString stringWithFormat:@"%@", editedFieldName]];
	
    // Pass current value to the edited object, then pop.
    [editedObject setValue:[self fileNameBuilder] forKey:editedFieldKey];
            
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancel {
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
#pragma mark Photo

- (IBAction)photoTapped {
     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
    
    // Write image to PNG
    
    [UIImagePNGRepresentation(selectedImage) writeToFile:[self pathBuilder] atomically:YES];
    // Create a thumbnail version of the image for the recipe object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 44.0 / size.width;
	} else {
		ratio = 44.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
		
    NSString *thumbNailPath = [NSString stringWithFormat:@"%@/%@-thumbNail.png",DOCUMENTS_FOLDER, textField.text];
    
    UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
    [UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext()) writeToFile:thumbNailPath atomically:YES];
    UIGraphicsEndImageContext();
    [self dismissModalViewControllerAnimated:YES];
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
}
*/

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)updatePhotoButton {
    //[photoButton setImage:[UIImage imageNamed:[self pathBuilder]] forState:UIControlStateNormal];
	
}

- (IBAction)record:(id)sender {
    [recorder stop];
    [self initRecorder];
    //self.statusLabel.text = @"I am recording.";
    [recorder record];
    textField.enabled = NO;
    stopButton.hidden = NO;
    recordButton.hidden = YES;
}

- (IBAction)stop:(id)sender{
    statusLabel.text = @"Stopped.";
    [recorder stop];
    playButton.hidden = NO;
    stopButton.hidden = YES;
}

- (IBAction)play:(id)sender{
    
    NSURL *url = [NSURL fileURLWithPath: [self pathBuilder]];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    if(!audioData)
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    audioPlayer = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
    audioPlayer.delegate = self;
    [audioPlayer play];
    playButton.hidden = YES;
    stopPlayerButton.hidden = NO;
    
}

-(IBAction)stopPlayer:(id)sender{
    [audioPlayer stop];
    stopPlayerButton.hidden = YES;
    recordButton.hidden = NO;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [sounds count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [sounds objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([sounds count] != 0)
        textField.text = [sounds objectAtIndex:row];
    else
        textField.text = @"You can record your own sound";
}

#pragma mark -
#pragma mark recorder

- (void) initRecorder{
    NSError *err;
    
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber  numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey,
                                    [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey, nil];
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[self pathBuilder]] settings:recordSettings error:&err];
    [recordSettings release];
       
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    recorder.delegate = self;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)txField {
    recordButton.enabled = YES;
	[txField resignFirstResponder];
    txField.enabled = NO;
    //self.placeHolder = [NSString stringWithFormat:@"%@", txField.text];
    return YES;
}



- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    //NSLog (@"audioRecorderDidFinishRecording:successfully:");
}

- (NSString *)pathBuilder{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",DOCUMENTS_FOLDER, [self fileNameBuilder]];
    return filePath;
}

- (NSString *)fileNameBuilder{
    NSString *name;
    if (editingImage)
        name = [NSString stringWithFormat:@"%@.jpg",textField.text];
    else if (editingTitle || editingSound)
        name = [NSString stringWithFormat:@"%@",textField.text];
    else 
        name = [NSString stringWithFormat:@"%@.caf",textField.text];
    return name;
}

- (NSArray *)initSounds{
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSArray *filesInDoc =[[NSArray alloc] initWithArray:[fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error] ];
    
    NSRange textRange;
    NSString *eachFile;
    for (eachFile in filesInDoc){
        textRange = [eachFile rangeOfString:@".caf"];
        if (textRange.location != NSNotFound)
            [sounds addObject:[NSString stringWithFormat:@"%@", eachFile]];
    }
    
    [filesInDoc release];
    return sounds;
}

@end
