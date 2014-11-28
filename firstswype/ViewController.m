//
//  ViewController.m
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "LocationViewController.h"


@implementation ViewController
@synthesize standardUserDefaults,urlString;

- (void)viewDidLoad
{
    [self performSelector:@selector(change) withObject:nil afterDelay:3];
    [self.navigationController setNavigationBarHidden:YES];
    standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)change{
    //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://google.com"]];
    
    LocationViewController *locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    urlString = [[NSString alloc] initWithString:@"http://givecentral.myworkforce.org/android/"];
    [standardUserDefaults setObject:urlString forKey:@"urlstring"];
    [self.navigationController pushViewController:locationViewController animated:YES];
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

@end
