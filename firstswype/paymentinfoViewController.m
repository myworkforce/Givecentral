//
//  paymentinfoViewController.m
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "paymentinfoViewController.h"
#import "paymentinfo1ViewController.h"



@implementation paymentinfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)Change:(id)sender
{
    paymentinfo1ViewController *PaymentInfo1ViewController = [[paymentinfo1ViewController alloc] initWithNibName:@"paymentinfo1ViewController" bundle:nil];
    [self.navigationController pushViewController:PaymentInfo1ViewController animated:YES];
}

-(void)Change1:(id)sender
{
   /* paymentinfo1ViewController *PaymentInfo1ViewController = [[paymentinfo1ViewController alloc] initWithNibName:@"paymentinfo1ViewController" bundle:nil];
    [self.navigationController pushViewController:PaymentInfo1ViewController animated:YES];*/
    exit(0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
