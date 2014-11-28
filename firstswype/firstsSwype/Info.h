//
//  Info.h
//  firstsSwype
//
//  Created by Administrator on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Info : NSObject
{
    NSString *location_id;
    NSString *location_name;
    NSString *major_location_name;
    
}

@property (nonatomic, retain) NSString	 *location_id;
@property (nonatomic, retain) NSString	 *location_name;
@property (nonatomic, retain) NSString	 *major_location_name;

@end
