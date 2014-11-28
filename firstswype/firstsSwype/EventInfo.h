//
//  EventInfo.h
//  NewProject1
//
//  Created by Myworkforce on 17/10/11.
//  Copyright 2011 myworkforce.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EventInfo: NSObject{

    NSString *event_id;
    NSString *event_title;
    NSString *details;
    NSString *loc_id;
    NSString *location_name;
    

}

@property (nonatomic, retain) NSString   *event_id;
@property (nonatomic, retain) NSString   *details;
@property (nonatomic, retain) NSString   *event_title;
@property (nonatomic, retain) NSString   *loc_id;
@property (nonatomic, retain) NSString   *location_name;
@end
