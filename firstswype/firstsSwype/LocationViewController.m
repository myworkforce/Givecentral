//
//  LocationViewController.m
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "eventViewController.h"


@implementation LocationViewController

@synthesize tableview,standardUserDefault,urlString,filteredLocations,standardUserDefaults,location,locArray,loc,locationArray,searchBar,responseData,doneButton,loc_name,loc_id,uuidString;

- (void)viewDidLoad
{
    
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",[standardUserDefault objectForKey:@"defaultloc_id"]);
    
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *documentPath = [documentFolder stringByAppendingPathComponent:@"location.plist"];
    NSArray *_array = [[NSArray alloc] init];
    _array = [NSArray arrayWithContentsOfFile:documentPath];
    NSLog(@"hgdshkdsjslahksfd  siaufhgjashgijshiughoihfvioh    %@ %d", _array,[_array count]);
    if ([_array count] !=0 ) {
        eventViewController *lvc= [[eventViewController alloc]initWithNibName:@"eventViewController" bundle:nil];
            
            [self.navigationController pushViewController:lvc animated:YES];
        }

    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    NSString *str = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    [standardUserDefaults synchronize];
    uuidString = [[NSString alloc] initWithFormat:@"SWIPE%@",str];
    [standardUserDefaults setObject:uuidString forKey:@"sessionid"];
        [self.view bringSubviewToFront:tableview];
    tableview.delegate=self;
    tableview.dataSource=self;
    
    
    urlString = [standardUserDefaults objectForKey:@"urlstring"];
    NSLog(@"MYKEY%@",urlString);
    NSString * string =[NSString stringWithFormat:@"%@android_loc_events.php?table=locations",[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    NSURLRequest * urls =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
    NSLog(@"%@",urls);
    [[NSURLConnection alloc] initWithRequest:urls delegate:self];
    responseData =[[NSMutableData alloc] init];
    locArray = [[NSMutableArray alloc] init];
    tableview.tableHeaderView = searchBar;
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}




-(void)menu:(id)sender{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to save it as your default location" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No",nil];
    [alert show];
    
}










- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    NSLog(@"index %@",alertView.title);
    if (alertView.numberOfButtons == 2) {
        
        if (buttonIndex == 0)
        {
            NSArray *array = [NSArray arrayWithObjects:loc_id, loc_name, nil];
            NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *documentPath = [documentFolder stringByAppendingPathComponent:@"location.plist"];
            
            [array writeToFile:documentPath atomically:YES];
            eventViewController * EventViewController = [[eventViewController alloc] initWithNibName:@"eventViewController" bundle:nil];
            //[self performSelector:@selector(menu:)];
            [standardUserDefaults setObject:loc.location_id forKey:@"location_id"];
            [standardUserDefaults setObject:loc.location_name forKey:@"location_name"];
            EventViewController.loc_name = loc.location_name;
            [self.navigationController pushViewController:EventViewController animated:YES];

        }
        else if (buttonIndex == 1)
        {
            eventViewController * EventViewController = [[eventViewController alloc] initWithNibName:@"eventViewController" bundle:nil];
            //[self performSelector:@selector(menu:)];
            [standardUserDefaults setObject:loc.location_name forKey:@"location_name"];
            [standardUserDefaults setObject:loc.location_id forKey:@"location_id"];
            EventViewController.loc_name = loc.location_name;
            [self.navigationController pushViewController:EventViewController animated:YES];
            
        }

    }
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
        location = [Info alloc];
        location.location_id = [registeredEvent objectForKey:@"location_id"];
        location.location_name = [registeredEvent objectForKey:@"location_name"]; 
        location.major_location_name = [registeredEvent objectForKey:@"major_location_name"];
        NSLog(@"loc %@",location.location_name);
        NSLog(@"loc %@",location.major_location_name);
        NSLog(@"loc %@",location.location_id);
        
        [locArray addObject:location];
        NSLog(@"%@",[locArray description]);   
    }
    //tempidentity = 1;
    NSLog(@"locArray %d",[locArray count]);
    //[activityIndicator stopAnimating];
    //[activityLabel setHidden:YES];
    [tableview reloadData];
    
    
    
    NSString *str = [NSString alloc];
    
    NSArray *NameArray = [NSArray alloc];
    
    locationArray = [[NSMutableArray alloc] init] ;
    NSLog(@"locarra %d",[locArray count]);
    NSMutableArray *tempdata = [[NSMutableArray alloc] init];   
    
    for(int i=0; i<[locArray count];i++){
        
        str = [[locArray objectAtIndex:i ] valueForKey:@"location_name"];
        NSLog(@"locarra %@",[locArray description]);
        [tempdata addObject:str];  
    }
    NameArray = tempdata;
    NSLog(@"Rajesh %@",[NameArray description]);
    
    NSDictionary *NameArrayInDict = [NSDictionary dictionaryWithObject:NameArray forKey:@"Names"];
    
    [locationArray addObject:NameArrayInDict]; 
    NSLog(@"shubham %@",locationArray);
    filteredLocations = [[NSMutableArray alloc] init];
    
    search = NO;
    Rowselect = YES;
    
    NSLog(@"inside detailviewdidload %@ ",[filteredLocations description]);
    
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
    NSLog(@"look %d",[[self locArray] count]);
    if(search)
    {
        return [filteredLocations count];
    }
    
    else if (tableView == tableview){
        //if (identity == 1) {
        return [locArray count];
        //return flickrPhotos.count;
        /* }
         else
         {
         return [[xmlParser locations] count];
         }*/
        
    }
    
    //NSLog(@"cellforrowatindexpath %d",[[xmlParser locations] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 88;
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Identifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // Configure the cell...
     /*loc = [locArray objectAtIndex:indexPath.row]; 
    cell.textLabel.text = loc.location_name;
    cell.detailTextLabel.text = loc.major_location_name;
    return cell;*/
    if(search)
    {
        /*[cell setFlickrPhoto:[flickrPhotos objectAtIndex:indexPath.row]];
         //CGRect artistFrame = CGRectMake(83, 3, 150, 25);
         
         //UILabel *artistLabel = [[[UILabel alloc] initWithFrame:artistFrame] autorelease];
         UILabel *artistLabel = (UILabel *) [cell.contentView viewWithTag:1];
         NSString *temp = [[NSString alloc] initWithFormat:@"%@ \n   SHUBHAM",[filteredLocations objectAtIndex:indexPath.row]];
         artistLabel.backgroundColor = [UIColor clearColor];
         artistLabel.font = [UIFont boldSystemFontOfSize:15];
         artistLabel.highlightedTextColor = [UIColor clearColor];
         
         artistLabel.lineBreakMode = UILineBreakModeWordWrap;
         artistLabel.numberOfLines = 0;
         artistLabel.text = temp;
         [cell.contentView addSubview:artistLabel];*/
        
        //cell.textLabel.frame = CGRectMake(83, 4, 150, 25);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.textLabel.text = [filteredLocations objectAtIndex:indexPath.row];
        //cell.textLabel.text = loc.location_name;
        //cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        //NSString *temp = [[NSString alloc] initWithFormat:@"   %@",loc.major_location_name];
        //cell.detailTextLabel.text= temp;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else if (tableView == tableview)
    {loc = [locArray objectAtIndex:indexPath.row];
        
        
            /*//NSLog(@"tempidentity == 1 %f",cell.textLabel.frame.size);
             //
             [cell setFlickrPhoto:[flickrPhotos objectAtIndex:indexPath.row]];
             //CGRect artistFrame = CGRectMake(83, 3, 150, 25);
             
             //UILabel *artistLabel = [[[UILabel alloc] initWithFrame:artistFrame] autorelease];
             UILabel *artistLabel = (UILabel *) [cell.contentView viewWithTag:1];
             artistLabel.backgroundColor = [UIColor clearColor];
             artistLabel.font = [UIFont boldSystemFontOfSize:15];
             artistLabel.highlightedTextColor = [UIColor clearColor];
             NSString *temp = [[NSString alloc] initWithFormat:@"%@ \n   SHUBHAM \n   %@",loc.location_name,loc.major_location_name];
             artistLabel.lineBreakMode = UILineBreakModeWordWrap;
             artistLabel.numberOfLines = 0;
             artistLabel.text = temp;
             [cell.contentView addSubview:artistLabel];
             UILabel *artistLabel = (UILabel *) [cell.contentView viewWithTag:1];
             artistLabel.text = @"SHUBHAM";
             artistLabel.textColor = [UIColor blackColor];
             [artistLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
             
             
             //cell.textLabel.frame = CGRectMake(83, 4, 150, 25);
             cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
             cell.textLabel.text = loc.location_name;
             cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
             NSString *temp = [[NSString alloc] initWithFormat:@"   %@",loc.major_location_name];
             cell.detailTextLabel.text= @"SHUBHAM";*/
            //cell.textLabel.frame = CGRectMake(83, 4, 150, 25);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
            cell.textLabel.text = loc.location_name;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
            NSString *temp = [[NSString alloc] initWithFormat:@"   %@",loc.major_location_name];
            cell.detailTextLabel.text= temp;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }

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
    loc = [locArray objectAtIndex:indexPath.row];
    
    loc_name = loc.location_name;
    loc_id = loc.location_id;
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
	
    
	[filteredLocations removeAllObjects];
	
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
	NSLog(@"array  %@",[locationArray description]);
    [doneButton setHidden:false];
	for (NSDictionary *dictionary in locationArray)
	{
		NSArray *array = [dictionary objectForKey:@"Names"];
		[searchArray addObjectsFromArray:array];
	}
	
	for (NSString *sTemp in searchArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		NSLog(@"stemp %@",sTemp);
		if (titleResultsRange.length > 0)
			[filteredLocations addObject:sTemp];
	}
	NSLog(@"shubham %@",filteredLocations);
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
