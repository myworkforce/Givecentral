//
//  eventViewController.h
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventInfo.h"

@interface eventViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableview;
    IBOutlet UILabel *label;
    NSString *loc_name;
    EventInfo *event;
    EventInfo *event1;
    NSMutableArray *eventArray;
    NSMutableArray *eventArr;
    NSMutableArray *filteredEvent;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *doneButton;
    NSString *loc_id;
    NSString *urlString;
    NSUserDefaults *standardUserDefaults;
    NSString *event_id;
    UIActivityIndicatorView *activityIndicator;
    UIView *container;
    CGRect frame;
    BOOL search;
	BOOL Rowselect;
}
@property(nonatomic, retain) IBOutlet UITableView * tableview;
@property(nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic, retain) NSString *loc_name;
@property(nonatomic, retain) EventInfo *event;
@property(nonatomic, retain) EventInfo *event1;
@property(nonatomic, retain) NSMutableArray *eventArray;
@property(nonatomic, retain) NSMutableArray *eventArr;
@property(nonatomic, retain) NSMutableArray *filteredEvent;
@property(nonatomic, retain) UISearchBar *searchBar;
@property(nonatomic, retain) IBOutlet UIButton *doneButton;
@property(nonatomic, retain) NSString *loc_id;
@property(nonatomic, retain) NSString *urlString;
@property(nonatomic, retain) NSUserDefaults *standardUserDefaults;
@property(nonatomic, retain) NSString *event_id;
- (void) search;
- (IBAction)doneButton:(id)sender;
- (IBAction)reLocation:(id)sender;
@end
