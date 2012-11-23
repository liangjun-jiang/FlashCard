//
//  FlipsideNavViewController.m
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.


//

#import "FlipsideNavViewController.h"
#import "SoundImage.h"
#import "DetailViewController.h"

@implementation FlipsideNavViewController
@synthesize delegate=_delegate, navController=_navController;
@synthesize managedObjectContext,addingManagedObjectContext;
@synthesize fetchedResultsController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", @"") 
                                                                   style:UIBarButtonItemStyleDone                                   target:self action:@selector(done:)]; 
    self.navigationItem.leftBarButtonItem = doneButton;
    
    // Configure the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"")  message:NSLocalizedString(@"NOFUN", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"FINE", @"") otherButtonTitles:nil];
        [alertView show];
        //exit(-1);  // Fail
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    fetchedResultController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Table view data source methods

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
	return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the sound image's name
	SoundImage *soundImage = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = soundImage.name;
}

//todo: we actually want to show the category's name
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	// Display the category's names as section headings.
    return [[[fetchedResultsController sections] objectAtIndex:section] name];
}
*/



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"")  message:NSLocalizedString(@"NOFUN", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"FINE", @"") otherButtonTitles:nil];
            [alertView show];
			//exit(-1);  // Fail
		}
    }   
}


#pragma mark -
#pragma mark Selection and moving

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // Create and push a detail view controller.
	DetailViewController *detailViewController = [[DetailViewController alloc] init];
    SoundImage *selectedSoundImage = (SoundImage *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected book to the new view controller.
    detailViewController.soundImage = selectedSoundImage;
	[self.navigationController pushViewController:detailViewController animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideNavViewControllerDidFinish:self];
}

- (IBAction)add:(id)sender {
    AddViewController *addViewController = [[AddViewController alloc] initWithNibName:@"DetailView" bundle:nil];
    addViewController.delegate = self;
    
    //create a new managed object for the new sound Image - set its persistent store cooridinator to the same as the from the fetched results controller;
    
    //NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];    
    NSManagedObjectContext *addingContext = [self managedObjectContext];
    
    //self.addingManagedObjectContext = addingContext;
    
    //[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultController managedObjectContext] persistentStoreCoordinator]];
    
    addViewController.soundImage = (SoundImage *)[NSEntityDescription insertNewObjectForEntityForName:@"SoundImage" inManagedObjectContext:addingContext];
    UINavigationController *navControllerWithAddView = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self.navController presentModalViewController:navControllerWithAddView animated:YES];
    navControllerWithAddView.navigationBar.barStyle = UIBarStyleBlackOpaque;
    addViewController.navController = navControllerWithAddView;
    
    
}

/**
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */
- (void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save {
   
	
	if (save) {
       
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) {
			// Update to handle the error appropriately.
            /*
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"WARNING", @"")  message:NSLocalizedString(@"NOFUN", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"FINE", @"") otherButtonTitles:nil];
            [alertView show];
            [alertView release];
             */
            //exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	}
	// Release the adding managed object context.
	self.addingManagedObjectContext = nil;
    
	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}


/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
}


#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"SoundImage" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	//NSSortDescriptor *imageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"imagePath" ascending:YES];
	NSArray *sortDescriptors = @[nameDescriptor]; //imageDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	//[imageDescriptor release];
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
    
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}


/*

- (void) dataTest {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSLog(@"context: %@", context);
    // Alice
    NSManagedObject *alice = [NSEntityDescription
                              insertNewObjectForEntityForName:@"SoundImage" 
                              inManagedObjectContext:context];
    [alice setValue:@"Alice" forKey:@"name"];
    
    // Bob
    NSManagedObject *bob = [NSEntityDescription
                            insertNewObjectForEntityForName:@"SoundImage" 
                            inManagedObjectContext:context];
    [bob setValue:@"Bob" forKey:@"name"];
    
    
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
        NSLog(@"%@", [info valueForKey:@"name"]);
        
    }        
    [fetchRequest release];
    
}
 */
@end
