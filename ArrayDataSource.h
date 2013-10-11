//
//  ArrayDataSource.h
//  Attendance
//
//  Created by Janusz Chudzynski on 6/21/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayDataSource : NSObject <UITableViewDataSource>
-(id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellId configureCellBlock:configureCell;
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

@end
