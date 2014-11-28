//
//  eventViewController.m
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "eventViewController.h"
#import "PaymentDetailViewController.h"
#import "EventInfo.h"
#import "LocationViewController.h"
#import "SwipeViewController.h"

@implementation eventViewController

@synthesize tableview,label,loc_name,event,event1,doneButton,searchBar,eventArray,filteredEvent,loc_id,urlString,standardUserDefaults,event_id,eventArr;

- (void)viewDidLoad
{
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *documentPath = [documentFolder stringByAppendingPathComponent:@"event.plist"];
    NSArray *_array = [[NSArray alloc] init];
    _array = [NSArray arrayWithContentsOfFile:documentPath];
    NSLog(@"hgdshkdsjslahksfd  siaufhgjashgijshiughoihfvioh    %@ %d", _array,[_array count]);
    if ([_array count] !=0 ) {
       // SwipeViewController *lvc= [[SwipeViewController alloc]initWithNibName:@"SwipeViewController" bundle:nil];
        
        //[self.navigationController pushViewController:lvc animated:YES];
        PaymentDetailViewController *lvc= [[PaymentDetailViewController alloc]initWithNibName:@"PaymentDetailViewController" bundle:nil];
        
        [self.navigationController pushViewController:lvc animated:YES];
    }

    [self.view bringSubviewToFront:tableview];
    tableview.delegate=self;
    tableview.dataSource=self;
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    loc_id = [standardUserDefaults objectForKey:@"location_id"];
    urlString = [standardUserDefaults objectForKey:@"urlstring"];
    label.text = [NSString stringWithFormat:@"Choose Event for %@",[standardUserDefaults objectForKey:@"location_name"]];
    NSString *url = [NSString stringWithFormat:@"%@android_loc_events.php?table=events&id=%@",[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[loc_id stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"%@",url);
    NSURLRequest *urls = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [[NSURLConnection alloc] initWithRequest:urls delegate:self];
    
    
    eventArray =[[NSMutableArray alloc] init];
    filteredEvent = [[NSMutableArray alloc] init];
    tableview.tableHeaderView = searchBar;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)menu:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to save it as your default event" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
    [alert show];
    
}










- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    NSLog(@"index %@",alertView.title);
    if (alertView.numberOfButtons == 2) {
        
        if (buttonIndex == 0)
        {
            NSArray *array = [NSArray arrayWithObjects:[standardUserDefaults objectForKey:@"eventid"], [standardUserDefaults objectForKey:@"eventtitle"], nil];
            NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *documentPath = [documentFolder stringByAppendingPathComponent:@"event.plist"];
            
            [array writeToFile:documentPath atomically:YES];
            
            //[self performSelector:@selector(menu:)];
           
            /*SwipeViewController *swipeViewController = [[SwipeViewController alloc] initWithNibName:@"SwipeViewController" bundle:nil];
            [self.navigationController pushViewController:swipeViewController animated:YES];*/
            PaymentDetailViewController *lvc= [[PaymentDetailViewController alloc]initWithNibName:@"PaymentDetailViewController" bundle:nil];
            
            [self.navigationController pushViewController:lvc animated:YES];
            
        }
        else if (buttonIndex == 1)
        {
            /*SwipeViewController *swipeViewController = [[SwipeViewController alloc] initWithNibName:@"SwipeViewController" bundle:nil];
            [self.navigationController pushViewController:swipeViewController animated:YES];*/
            PaymentDetailViewController *lvc= [[PaymentDetailViewController alloc]initWithNibName:@"PaymentDetailViewController" bundle:nil];
            
            [self.navigationController pushViewController:lvc animated:YES];
            
        }
    }
}





-(void)reLocation:(id)sender{
    
    NSArray *array = [[NSArray alloc] init];
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *documentPath = [documentFolder stringByAppendingPathComponent:@"location.plist"];
    
    [array writeToFile:documentPath atomically:YES];
    LocationViewController *locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //self.responseData = nil;
    //NSLog(@"stringssss          %@      ",responseString);
    // Create a dictionary from the JSON string
    
    
    NSMutableArray *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"shibu %d",[results count]);
    //NSMutableArray *tempid = [[NSMutableArray alloc] init];
    //NSMutableArray *tempmethod = [[NSMutableArray alloc] init];
    //NSMutableArray *temptype = [[NSMutableArray alloc] init];
    //fetch the data
    for (int i =0;i<[results count]; i++) {
        
        NSDictionary *registeredEvent = [results objectAtIndex:i];
        NSLog(@"dict %@",registeredEvent);
        event = [EventInfo alloc];
        event.event_id = [registeredEvent objectForKey:@"event_id"];
        event.event_title = [registeredEvent objectForKey:@"event_title"]; 
        event.location_name = [registeredEvent objectForKey:@"location_name"];
        NSLog(@"loc %@",event.event_title);
        NSLog(@"loc %@",event.event_id);
        NSLog(@"loc %@",event.location_name);
        [eventArray addObject:event];
        NSLog(@"sdjbfashgfshdgh %@",[eventArray description]);   
         NSLog(@"eventArray %d",[eventArray count]);
    }
    //tempidentity = 1;
    NSLog(@"eventArray %d",[eventArray count]);
    //[activityIndicator stopAnimating];
    //[activityLabel setHidden:YES];
    [tableview reloadData];
    
    
    
    NSString *str = [NSString alloc];
    
    NSArray *NameArray = [NSArray alloc];
    
    eventArr = [[NSMutableArray alloc] init] ;
    NSLog(@"eventArray %d",[eventArray count]);
    NSMutableArray *tempdata = [[NSMutableArray alloc] init];   
    
    for(int i=0; i<[eventArray count];i++){
        
        str = [[eventArray objectAtIndex:i ] valueForKey:@"event_title"];
        NSLog(@"eventArray %@",[eventArray description]);
        [tempdata addObject:str];  
    }
    NameArray = tempdata;
    NSLog(@"Rajesh %@",[NameArray description]);
    
    NSDictionary *NameArrayInDict = [NSDictionary dictionaryWithObject:NameArray forKey:@"Names"];
    
    [eventArr addObject:NameArrayInDict]; 
    NSLog(@"shubham %@",eventArr);
    filteredEvent = [[NSMutableArray alloc] init];
    
   search= NO;
   Rowselect = YES;
    
    NSLog(@"inside detailviewdidload %@ ",[filteredEvent description]);
    
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"look %d",[[self eventArray] count]);
    if(search)
    {
        return [filteredEvent count];
    }
    
    else if (tableView == tableview)
    {
        //if (identity == 1) {
        return [eventArray count];
      }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    event = [eventArray objectAtIndex:indexPath.row];

    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.textLabel.text = event.event_title;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    NSString *temp = [[NSString alloc] initWithFormat:@"   %@",event.location_name];
    cell.detailTextLabel.text= temp;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    event = [eventArray objectAtIndex:indexPath.row];
    event_id = event.event_id;
    NSLog(@"vent id %@",event_id);
    [standardUserDefaults setObject:event_id forKey:@"eventid"];
    [standardUserDefaults setObject:event.event_title forKey:@"eventtitle"];
    [self performSelector:@selector(menu:)];


}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	
	if(search)
		return;
	
	search = YES;
	Rowselect = NO;
	self.tableview.scrollEnabled = NO;
	
	NSLog(@"start search");
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                              target:self action:@selector(doneButton:)];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
    
	[filteredEvent removeAllObjects];
	
	if([searchBar.text length] > 0) {
		
        NSLog(@"no searchs");
		search = YES;
		Rowselect = YES;
		self.tableview.scrollEnabled = YES;
		[self search];
	}
	else {
        NSLog(@"search");
		
		search = NO;
		Rowselect = NO;
		self.tableview.scrollEnabled = NO;
	}
	
	[tableview reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar 
{
	
	[self search];
}

- (void) search {
	
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	NSLog(@"array  %@",[eventArr description]);
    [doneButton setHidden:false];
	for (NSDictionary *dictionary in eventArr)
	{
		NSArray *array = [dictionary objectForKey:@"Names"];
		[searchArray addObjectsFromArray:array];
	}
	
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		NSLog(@"stemp %@",sTemp);
		if (titleResultsRange.length > 0)
			[filteredEvent addObject:sTemp];
	}
	NSLog(@"shubham %@",filteredEvent);
	//[searchArray release];
	searchArray = nil;
}

- (void) doneButton:(id)sender {
	
	
    searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	Rowselect = YES;
	search = NO;
	NSLog(@"shivansh");
    self.navigationItem.rightBarButtonItem = nil;
	self.tableview.scrollEnabled = YES;
	
	[self.tableview reloadData];
    [doneButton setHidden:true];
}


@end
