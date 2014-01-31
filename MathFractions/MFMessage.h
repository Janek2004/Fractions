//
//  MFMessage.h
//  Fractio
//
//  Created by sadmin on 1/30/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFMessage : NSObject

@property (nonatomic,strong) NSString * studentid;
@property (nonatomic,strong) NSString * teacherid;
@property (nonatomic,strong) NSString * teachername;
@property (nonatomic,strong) NSString * teacherlastname;
@property (nonatomic,strong) NSString * messagetext;
@property (nonatomic,strong)  NSDate * messagedate;
@end
