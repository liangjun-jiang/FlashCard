//
//  EditingViewController.m
//  MySoundImage
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.

//

#import "EditingViewController.h"
#import "PhotoViewController.h"

@interface EditingViewController (PrivateMethods)
- (void)updatePhotoButton;
@end

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation EditingViewController

@synthesize textField, editedObject, editedFieldKey, editedFieldName, editingTitle, editingImage, editingSound, editingVoice, soundPicker,photoButton, recordButton, sounds, statusLabel, recorder, audioPlayer, playButton, stopButton, stopPlayerButton, photoImageView, saveButton,cancelButton;





#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.title = editedFieldName;
    
    // Configure the save and cancel buttons.
	
    saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SAVE", @"") style:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
	
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", @"") style:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    sounds = [[NSMutableArray alloc] init];
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
        textField.placeholder=NSLocalizedString(@"ENTERNAME", @"");
        [textField becomeFirstResponder];
        photoButton.hidden = NO;
       
    } else if(editingSound){
        textField.placeholder=NSLocalizedString(@"HINT", @"");
        textField.enabled = NO;
//        [self initSounds];
//        [self obtainAllSounds];
        soundPicker.hidden = NO;
    } else if (editingVoice){
            
        textField.hidden = NO;
        textField.placeholder = NSLocalizedString(@"ENTERNAME", @"");
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
    
     [photoButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@-thumbNail.png",DOCUMENTS_FOLDER, textField.text]] forState:UIControlStateNormal];      
}
*/

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}

/* todo:
- (void)updatePhotoButton {
    
  
	 How to present the photo button depends on the editing state and whether the recipe has a thumbnail image.
	 * If the recipe has a thumbnail, set the button's highlighted state to the same as the editing state (it's highlighted if editing).
	 * If the recipe doesn't have a thumbnail, then: if editing, enable the button and show an image that says "Choose Photo" or similar; if not editing then disable the button and show nothing.  
	 
    
    BOOL editing = self.editing;
    
    if ([UIImage imageNamed:[NSString stringWithFormat:@"%@/%@-thumbNail.png",DOCUMENTS_FOLDER, textField.text]]!=nil)
        photoButton.highlighted = editing;
    else{
        NSLog(@"so u r called?");
        photoButton.enabled = editing;
    
    if (self.editing) {
			[photoButton setImage:[UIImage imageNamed:@"choosePhoto.png"] forState:UIControlStateNormal];
		} else {
            [photoButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@-thumbNail.png",DOCUMENTS_FOLDER, textField.text]] forState:UIControlStateNormal];  
        }
    }
  
   }
  */

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
    //tatusLabel.text = NSLocalizedString(@"STOP",@"");
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
    return sounds[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([sounds count] != 0)
        textField.text = sounds[row];
    else
        textField.text = NSLocalizedString(@"RECORD HINT", @"");
}

#pragma mark -
#pragma mark recorder

- (void) initRecorder{
    NSError *err;
    
    NSDictionary *recordSettings = @{AVSampleRateKey: @44100.0f,
                                    AVFormatIDKey: @(kAudioFormatAppleLossless),
                                    AVNumberOfChannelsKey: @1,
                                    AVEncoderAudioQualityKey: @(AVAudioQualityMax)};
    recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[self pathBuilder]] settings:recordSettings error:&err];
       
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"WARNING", @"")
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:NSLocalizedString(@"OK", @"")
                         otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    recorder.delegate = self;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)txField {
    recordButton.enabled = YES;
	[txField resignFirstResponder];
    txField.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.style = true;
    
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

//- (NSMutbleArray *)obtainAllSounds{
//    
//    NSError *error;
//    NSFileManager *fileMgr = [NSFileManager defaultManager];
//    NSString *documentsDirectory = [NSHomeDirectory()
//                                    stringByAppendingPathComponent:@"Documents"];
//    NSArray *filesInDoc =[[NSArray alloc] initWithArray:[fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error] ];
//    
//    NSRange textRange;
//    NSString *eachFile;
//    
//    NSMutableArray *soundsArray = [[NSMutableArray alloc] init];
//    for (eachFile in filesInDoc){
//        textRange = [eachFile rangeOfString:@".caf"];
//        if (textRange.location != NSNotFound)
//            [soundsArray addObject:[NSString stringWithFormat:@"%@", eachFile]];
//    }
//    
//    self.navigationItem.rightBarButtonItem.enabled=YES;
//    
//    [filesInDoc release];
//    return soundsArray;
//}

@end
