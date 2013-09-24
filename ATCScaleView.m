//
//  ATCScaleView.m
//  ScaleView
//
/*
 Author: Janusz Chudzynski
 The MIT License (MIT)
 
 Copyright 2010 University of West Florida. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "ATCScaleView.h"
#import "MFFraction.h"

#define RectSize 25
#define WIDTH 0.7
#define alpha_interval 0.5

@interface ATCScaleView()
{
    CGPoint leftOrigin;
    CGPoint rightOrigin;
    CGPoint touchOrigin;
    float scaleWidth;
    float alpha;
}
@property(nonatomic,strong) UIPanGestureRecognizer * upGesture;
@property(nonatomic,strong) UITapGestureRecognizer * tapGesture;
@property(nonatomic,strong) UILabel * label;
@end



@implementation ATCScaleView

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};

-(MFFraction *)calculateScore{
 
    return [MFFraction new];
}

-(BOOL)checkAnswer{
    MFFraction * mf = [self calculateScore];
    MFFraction * mf1 = self.currentFraction;
    
    return [mf isEqual: mf1];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        //get width
        float width = WIDTH * frame.size.width;
        float x1 = self.center.x - width/2.0;
        float x2 = self.center.x + width/2.0;
        alpha = 180;
        
        leftOrigin = CGPointMake(x1, self.center.y);
        rightOrigin = CGPointMake(x2, self.center.y);
        scaleWidth = width;
        
        _upGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(upGestureTriggered:)];
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reset)];
        
        _tapGesture.numberOfTapsRequired = 3;
        
        _upGesture.minimumNumberOfTouches =1;
        _upGesture.maximumNumberOfTouches =1;
        
        [self addGestureRecognizer:_upGesture];
        [self addGestureRecognizer:_tapGesture];
        
    }
    return self;
}

-(void)reset{
    id k =[self initWithFrame:self.bounds];
    k=nil;
    [self setNeedsDisplay];
}



-(void)upGestureTriggered:(UIPanGestureRecognizer *)recognizer{
    CGPoint  touch = [recognizer locationInView:self];
    touchOrigin = touch;
    //get distance
    float d1 = abs([self calculateDistanceBetweenPoint:touch andPoint:leftOrigin]);
    float d2 = abs([self calculateDistanceBetweenPoint:touch andPoint:rightOrigin]);
    NSLog(@" %f %f",d1, d2);
    
    //if it's closer then some threshold
    CGPoint velocity = [recognizer velocityInView:self];
    if(d1<15)
    {
       
        if(velocity.y > 0)
        {
            alpha -=alpha_interval;
            
            if(abs(alpha)<160 )
            {
                alpha =160;
                return;
            }
           
            
            float x = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha));
            float y = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha));
            
            leftOrigin.x = x;
            leftOrigin.y = y;
            
            float x1 = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha+180));
            float y1 = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha+180));
            
            rightOrigin.x = x1;
            rightOrigin.y = y1;
            
            
        }
        else
        {
            alpha +=alpha_interval;
            
            if(abs(alpha)>200 )
            {
                alpha = 200;
                return;
            }
            
            
            float x = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha));
            float y = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha));
            
            leftOrigin.x = x;
            leftOrigin.y = y;
            
            float x1 = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha+180));
            float y1 = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha+180));
            
            rightOrigin.x = x1;
            rightOrigin.y = y1;
            
            
        }
               
    }
    
    
    if(d2<15)
    {
        if(velocity.y > 0)
        {
            alpha +=alpha_interval;


            if(alpha>200){
                alpha =200;
                return;}
            

            
            float x = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha));
            float y = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha));
            
            leftOrigin.x = x;
            leftOrigin.y = y;
            
            float x1 = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha+180));
            float y1 = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha+180));
            
            rightOrigin.x = x1;
            rightOrigin.y = y1;
            
                       
        }
        else
        {
            alpha -=alpha_interval;
            
            if(alpha<160){
                alpha = 160;
                return;}
            
           
            
            float x = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha));
            float y = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha));
            
            leftOrigin.x = x;
            leftOrigin.y = y;
            
            float x1 = self.center.x + scaleWidth/2.0 * cos(DegreesToRadians(alpha+180));
            float y1 = self.center.y + scaleWidth/2.0 * sin(DegreesToRadians(alpha+180));
            
            rightOrigin.x = x1;
            rightOrigin.y = y1;
            
            
        }

        
    }
    NSLog(@"Alpha %f",alpha);
    
    [self setNeedsDisplay];

   
    
}



-(float)calculateDistanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2{

    CGFloat xDist = (p2.x - p1.x); //[2]
    CGFloat yDist = (p2.y - p1.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    return distance;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawScale:leftOrigin right:rightOrigin];
    [self drawSign];
}

-(void)drawSign{
   int labelWidth = self.frame.size.width * 0.5;
    CGRect textRect = CGRectMake(self.center.x-labelWidth/2.0,self.center.y+ 40,labelWidth,30);
    
    NSString *textContent;
    if(alpha >=175 && alpha <=185){
        textContent = @"=";
    }
    
    else if(alpha >185 ){
        textContent = @">";
    }

    else if(alpha <175 ){
        textContent = @"<";
    }
        
    
    [[UIColor blackColor] setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    
}

-(void)drawScale:(CGPoint)left right:(CGPoint)right{
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.886 green: 0 blue: 0 alpha: 1];
    UIColor* color1 = [UIColor colorWithRed: 0.486 green: 0 blue: 0 alpha: 1];
    UIColor* color2 = [UIColor colorWithRed: 0.886 green: 0.886 blue: 0 alpha: 1];
    
    CGPoint center = self.center;
    

    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(center.x,center.y, 13, 12)];
    [color setFill];
    [ovalPath fill];
    [[UIColor blackColor] setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];

    
    UIBezierPath* touchPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(touchOrigin.x, touchOrigin.y, 13, 12)];
    [color setFill];
    [touchPath fill];
    [[UIColor blackColor] setStroke];
    touchPath.lineWidth = 1;
    [touchPath stroke];

    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: left];
    [bezierPath addLineToPoint: right];
    [color setFill];
    [bezierPath fill];
    [[UIColor blackColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
 
    
    //// Rectangle Drawing
    CGSize rectSize = CGSizeMake(RectSize, RectSize);
    CGPoint or1 = left;
    or1.x  -=rectSize.height/2.0;
    or1.y -=rectSize.height/2.0;
 
    CGPoint or2 = right;
    or2.x  -=rectSize.height/2.0;
    or2.y -=rectSize.height/2.0;

    CGRect leftRect = CGRectMake(or1.x, or1.y, rectSize.width, rectSize.height);
    CGRect rightRect = CGRectMake(or2.x, or2.y, rectSize.width, rectSize.height);
    
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: leftRect];
    [color1 setFill];
    [rectanglePath fill];
    [[UIColor blackColor] setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];

   
    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: rightRect];
    [color2 setFill];
    [rectangle2Path fill];
    [[UIColor blackColor] setStroke];
    rectangle2Path.lineWidth = 1;
    [rectangle2Path stroke];

    
    
}


@end
