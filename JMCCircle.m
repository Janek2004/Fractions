//
//  JMCCircle.m
//  CoreGraphicsCircles
//
//  Created by sadmin on 6/8/14.
//  Copyright (c) 2014 Janusz Chudzynski. All rights reserved.
//

#import "JMCCircle.h"
@interface JMCCircle()
@property(nonatomic,assign) double start;
@property(nonatomic,assign) double step;
@property(nonatomic,assign) double end;

@end

@implementation JMCCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(float)degreesToRadians:(float)degrees{
    
    return  degrees * M_PI/180;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    int radius = CGRectGetHeight(self.bounds)>CGRectGetWidth(self.bounds)?CGRectGetWidth(self.bounds)/2.0:CGRectGetHeight(self.bounds)/2.0;
    radius = 0.9 * radius;
    CGPoint center =  CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    
    // Drawing Background Circle Code
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGMutablePathRef circlePath = CGPathCreateMutable();
   
    CGPathAddArc(circlePath, nil, center.x, center.y, radius, [self degreesToRadians:0], [self degreesToRadians:360], NO);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddPath(context,circlePath);

    CGContextFillPath(context);
    
    // Drawing selected region
    [self drawSelectedRegion:center radius:radius context:context start:1 step:self.step   endDegree:self.end];
    
}



-(void)setStart:(double)start step:(double)step endDegree:(double)endDegree;{
    self.start = start;
    self.step = step;
    self.end = endDegree;
    
    [self setNeedsDisplay];
}


-(void)drawSelectedRegion:(CGPoint)center radius:(float)radius context:(CGContextRef)context start:(float)startDegree step:(float)step endDegree:(float)endDegree{
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, center.x, center.y);

    CGPoint start = [self calculatePointOnCircleWithRadius:radius center:center degrees:startDegree];
    CGPathAddLineToPoint(path, nil, start.x, start.y);

    
    for(int i= startDegree; i<=endDegree; i=i+step){
        CGPathAddArc(path, nil, center.x, center.y, radius, [self degreesToRadians:i], [self degreesToRadians:i+step], NO);
        CGPathAddLineToPoint(path, nil, center.x, center.y);
    }
    
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context, 0.8);
    CGContextAddPath(context,path);
    CGContextDrawPath(context, kCGPathFillStroke);

}

-(CGPoint)calculatePointOnCircleWithRadius:(float)radius center:(CGPoint)center degrees:(float)degrees{
    float x = radius*cos([self degreesToRadians:degrees]) + center.x;
    float y = radius*sin([self degreesToRadians:degrees]) + center.y;
    return  CGPointMake(x, y);
    
}



@end
