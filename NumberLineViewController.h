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
@interface NumberLineViewController : UIViewController

-(BOOL)checkAnswer:(void (^)(BOOL s))completed;
-(void)reset;
@property (nonatomic,strong) NSArray * currentFractions;
@end
