//
//  MFFractionView.m
//  MathFractions
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

#import "MFFractionView.h"
#import "MFFraction.h"

@implementation MFFractionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setFraction:(MFFraction *)fraction{
    _fraction =fraction;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{


    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor clearColor]CGColor]);
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
   // Drawing code
    [self drawFractions];

}

-(void)drawFractions{
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Abstracted Attributes
    NSString* textContent =[NSString stringWithFormat:@"%d",self.fraction.numerator];
    
    NSString* text2Content = [NSString stringWithFormat:@"%d",self.fraction.denominator];
    

    //// Rounded Rectangle Drawing
    CGRect roundedRect =CGRectMake(0.5, 0.5, CGRectGetWidth(self.bounds)-0.5, CGRectGetHeight(self.bounds)-0.5) ;

    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius: 4];
    [[UIColor whiteColor] setFill];
    [roundedRectanglePath fill];
    [[UIColor blackColor] setStroke];
    roundedRectanglePath.lineWidth = 1;
   /// [roundedRectanglePath stroke];
    
    
    CGPoint center = self.center;
    //// Rectangle Drawing
    float w = 0.7 * CGRectGetWidth(roundedRect);
    float x = 0.5 +  (CGRectGetWidth(roundedRect) - w)/2.0;
    float h = 2;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(x,center.y-h/2.0, w, h)];
    [color setFill];
    [rectanglePath fill];
    [[UIColor blackColor] setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];

    CGRect textRect = CGRectMake(x, 45, w, center.y-5);
    
    
    [[UIColor blackColor] setFill];
    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica" size: 30] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    
    //// Text 2 Drawing
    CGRect text2Rect = CGRectMake(x, center.y +5, w, CGRectGetHeight(self.bounds)-5);
    
    [[UIColor blackColor] setFill];
    [text2Content drawInRect: text2Rect withFont: [UIFont fontWithName: @"Helvetica" size: 30] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    

}
 
 

@end
