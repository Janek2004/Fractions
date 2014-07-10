//
//  JMCCircle.h
//  CoreGraphicsCircles
//
//  Created by sadmin on 6/8/14.
//  Copyright (c) 2014 Janusz Chudzynski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCCircle : UIView

-(void)setStart:(double)start step:(double)step endDegree:(double)endDegree;

-(float)degreesToRadians:(float)degrees;
@end
