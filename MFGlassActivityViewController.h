//
//  MFGlassActivityViewController.h
//  MathFractions
//
//  Created by Terry Lewis II on 10/3/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFPracticeRequiredMethods.h"
@interface MFGlassActivityViewController : UIViewController<MFPracticeRequiredMethods>
-(void)setCurrentFractions:(NSArray *)currentFractions;
-(BOOL)checkAnswer;
@end
