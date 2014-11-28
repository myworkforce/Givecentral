//
//  LocationViewController.h
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Info.h"
@interface LocationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableview;
    Info *location;
    Info *loc;
    NSString *loc_name;
    NSString *loc_id; 
    NSMutableArray *locationArray;
    NSMutableArray *locArray;
    NSMutableData *responseData;
    NSUserDefaults *standardUserDefaults;
    NSString * urlString;
    NSString * uuidString;
    IBOutlet UISearchBar* searchBar;
    NSMutableArray *filteredLocations;
    NSString *ses;
    BOOL search;
	BOOL Rowselect;
    UIActivityIndicatorView *activityIndicator;
    UIView *container;
    CGRect frame;
    IBOutlet UIButton *doneButton;
    NSUserDefaults *standardUserDefault;

}
@property (nonatomic, retain) NSString *loc_id; 
@property (nonatomic, retain) NSString *loc_name;
@property (nonatomic, retain) NSUserDefaults *standardUserDefault;
@property (retain, nonatomic) NSMutableArray *filteredLocations;
@property (nonatomic, retain) NSUserDefaults *standardUserDefaults;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *uuidString;
@property (retain, nonatomic) IBOutlet UISearchBar* searchBar;
//@property (retain, nonatomic) UISearchDisplayController* searchController;
@property (retain, nonatomic) NSMutableArray *locationArray;
@property (retain, nonatomic) NSMutableArray *locArray;
@property(nonatomic, retain) Info *location;
@property(nonatomic, retain) Info *loc;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property(nonatomic, retain) IBOutlet UITableView * tableview;
- (void) search;
- (IBAction)doneButton:(id)sender;
@end
