//
//  ArrayDataSource.m
//  Attendance
//
//  Created by Janusz Chudzynski on 6/21/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "ArrayDataSource.h"
typedef void (^ConfigureCellBlock)();
@interface ArrayDataSource(){
    ConfigureCellBlock configureCellBlock;
    NSString * cellIdentifier;
    
}
@property(nonatomic,strong)NSArray * items;

@end


@implementation ArrayDataSource


-(id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellId configureCellBlock:configureCell{
    
    self = [super init];
    if(self){
        cellIdentifier = cellId;
        configureCellBlock = configureCell;
        _items = items;
    }
    return self;
}


- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return _items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    configureCellBlock(cell,item);
    
    return cell;
}



@end
