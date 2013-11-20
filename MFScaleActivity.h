//
//  MFScaleActivity.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 11/20/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFScaleActivity : UIViewController
-(BOOL)checkAnswer:(void (^)(BOOL s))completed;
@property (nonatomic,strong) NSArray * currentFractions;

@end
