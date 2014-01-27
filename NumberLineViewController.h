//
//  NumberLineViewController.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 11/20/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFPracticeRequiredMethods.h"

@class MFFraction;
@interface NumberLineViewController : UIViewController <MFPracticeRequiredMethods>

-(void)reset;
@property (nonatomic,strong) NSArray * currentFractions;
@end
