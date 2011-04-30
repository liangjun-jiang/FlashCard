//
//  DetailViewController.m
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
//

#import "DetailViewController.h"
#import "SoundImage.h"
#import "EditingViewController.h"


@implementation DetailViewController
@synthesize soundImage, dateFormatter, undoManager;
@synthesize tableView=_tableView;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.clearsSelectionOnViewWillAppear = NO;

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;

    
}

- (void)viewDidUnload
{
    self.dateFormatter = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self updateRightBarButtonItemState];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	
	/*
	 When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
	 When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
	 */
	if (editing) {
		[self setUpUndoManager];
	}
	else {
		[self cleanUpUndoManager];
		// Save the changes.
		NSError *error;
		if (![soundImage.managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)updateRightBarButtonItemState {
	// Conditionally enable the right bar button item -- it should only be enabled if the book is in a valid state for saving.
    self.navigationItem.rightBarButtonItem.enabled = [soundImage validateForUpdate:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = soundImage.name;
            break;
        case 1:
            cell.textLabel.text = @"Image";
            cell.detailTextLabel.text = soundImage.imagePath;
            break;
        case 2:
            cell.textLabel.text = @"Sound";
            cell.detailTextLabel.text = soundImage.soundPath;
            break;    
        case 3:
            cell.textLabel.text = @"Voice";
            cell.detailTextLabel.text = soundImage.voicePath;
            break;    
            
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (self.editing)? indexPath:nil;
    
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (!self.editing) return;
	
    EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
    
    controller.editedObject = soundImage;
    switch (indexPath.row) {
            
        case 0: {
            controller.editedFieldKey = @"name";
            controller.editedFieldName = NSLocalizedString(@"Name", @"display name for name");
            controller.editingTitle = YES;
        } break;
        case 1: {
            controller.editedFieldKey = @"imagePath";
			controller.editedFieldName = NSLocalizedString(@"Image", @"display imagePath for image");
			controller.editingImage = YES;
        } break;
        case 2: {
            controller.editedFieldKey = @"soundPath";
			controller.editedFieldName = NSLocalizedString(@"Sound", @"display name for sound");
			controller.editingSound = YES;
        } break;
        case 3: {
            controller.editedFieldKey = @"voicePath";
			controller.editedFieldName = NSLocalizedString(@"Voice", @"display name for voice");
			controller.editingVoice = YES;
        } break;    
            
    }
	
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}


-(void)setUpUndoManager{
    /*
	 If the book's managed object context doesn't already have an undo manager, then create one and set it for the context and self.
	 The view controller needs to keep a reference to the undo manager it creates so that it can determine whether to remove the undo manager when editing finishes.
	 */
	if (soundImage.managedObjectContext.undoManager == nil) {
		
		NSUndoManager *anUndoManager = [[NSUndoManager alloc] init];
		[anUndoManager setLevelsOfUndo:3];
		self.undoManager = anUndoManager;
		[anUndoManager release];
		
		soundImage.managedObjectContext.undoManager = undoManager;
	}
	
	// Register as an observer of the book's context's undo manager.
	NSUndoManager *soundImageUndoManager = soundImage.managedObjectContext.undoManager;
	
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(undoManagerDidUndo:) name:NSUndoManagerDidUndoChangeNotification object:soundImageUndoManager];
	[dnc addObserver:self selector:@selector(undoManagerDidRedo:) name:NSUndoManagerDidRedoChangeNotification object:soundImageUndoManager];
    
}
// from Apple's sample code: CoreDataBooks: DetailViewController.m
-(void)cleanUpUndoManager{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if (soundImage.managedObjectContext.undoManager == undoManager) {
		soundImage.managedObjectContext.undoManager = nil;
		self.undoManager = nil;
	}
    
}

- (NSUndoManager *)undoManager {
	return soundImage.managedObjectContext.undoManager;
}




- (void)undoManagerDidUndo:(NSNotification *)notification {
	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


- (void)undoManagerDidRedo:(NSNotification *)notification {
	[self.tableView reloadData];
	[self updateRightBarButtonItemState];
}


/*
 The view controller must be first responder in order to be able to receive shake events for undo. It should resign first responder status when it disappears.
 */
- (BOOL)canBecomeFirstResponder {
	return YES;
}




#pragma mark -
#pragma mark Date Formatter

- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
	return dateFormatter;
}


- (void)dealloc
{
    [soundImage release];
    [undoManager release];
    [super dealloc];
}

@end