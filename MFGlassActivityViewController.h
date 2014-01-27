//
//  MFGlassActivityViewController.h
//  MathFractions
//
//  Created by Terry Lewis II on 10/3/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFPracticeRequiredMethods.h"

@interface MFGlassActivityViewController : UIViewController <MFPracticeRequiredMethods>
@property (nonatomic,strong) NSArray * currentFractions;
-(void)setCurrentFractions:(NSArray *)currentFractions;

@end
