//
//  ViewController.h
//  firstsSwype
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    NSUserDefaults *standardUserDefaults;
    NSString *urlString;
}
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSUserDefaults *standardUserDefaults;
@end
