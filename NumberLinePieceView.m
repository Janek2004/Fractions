//
//  NumberLineView.m
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

#import "NumberLinePieceView.h"
#import "Segment.h"
#define maxSegmentsNumber 10
#define minSegmentsNumber 1
@interface NumberLinePieceView()
@property int segments;

@property (nonatomic,strong) UITapGestureRecognizer * tapRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer * doubleTapRecognizer;
@property CGPoint currentPoint;
@property BOOL segmentsNumberChanged;
@property (nonatomic,strong) UIImage  *star;
@property (nonatomic,strong) UIImage  *segment;
@property (nonatomic,strong) UIImage  *chocolate;



@end
@implementation NumberLinePieceView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //debugging only
        _segment = [UIImage imageNamed:@"chocopiece"];
        _star = [UIImage imageNamed:@"chocostar"];
        _chocolate = [UIImage imageNamed:@"chocothin"];
  
        
        _segments = 1;
        _segmentsArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        _doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        _tapRecognizer.numberOfTapsRequired = 1;
        _tapRecognizer.numberOfTouchesRequired =1;
        
        _doubleTapRecognizer.numberOfTapsRequired = 2;
        _doubleTapRecognizer.numberOfTouchesRequired =1;
        
        [_tapRecognizer requireGestureRecognizerToFail:_doubleTapRecognizer];
        
        [self addGestureRecognizer:_tapRecognizer];
        [self addGestureRecognizer:_doubleTapRecognizer];
        self.segmentsNumberChanged = YES;
        self.backgroundColor= [UIColor clearColor];
        
    }
    return self;
}




-(void)tapGesture:(UITapGestureRecognizer*)r{
    //for making sure that user tapped the right thing.
    CGPoint point = [r locationInView:self];
    _currentPoint = point;
    
    CGRect lineRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  
    if(CGRectContainsPoint(lineRect, point)){
        if(r==_tapRecognizer){
            int i=0;
            for(Segment * s in self.segmentsArray)
            {
                if(CGRectContainsPoint(s.frame, point))
                {
                    s.selected = !s.selected;
                    self.segmentsArray[i]=s;
                    [self getCurrentValue];
                    [self setNeedsDisplay];
                    return;
                }
                i++;
            }
            
            self.segmentsNumberChanged = NO;
        }
        if(r==_doubleTapRecognizer){
            NSLog(@"double tap");
            if(_segments<maxSegmentsNumber){
                _segments++;
            }
            else{
               _segments = minSegmentsNumber;
            }
        }
       self.segmentsNumberChanged = YES;
        [self.segmentsArray removeAllObjects];
       [self setNeedsDisplay];
    }
  }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Draw Background
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor]CGColor]);
    CGContextFillRect(ctx, self.bounds);
   
    if(self.segmentsNumberChanged){
        [self prepareSegments];
        self.segmentsNumberChanged  = NO;
    }
    [self drawSegments];
}




-(void)prepareSegments{
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, [[UIColor grayColor]CGColor]);
    
    
    int margin = 40;
    int lineH = 10;
    //int segmentHeight = 35;
    int segmentHeight = 0.8 * CGRectGetHeight(self.frame);
    lineH = 0.1 * CGRectGetHeight(self.frame);
   
    
    //get line width
    float lineWidth = self.bounds.size.width-2*margin;
    
    //get nr of segments
    float lineSegmentWidth = lineWidth *1.0f/(self.segments)*1.0f;
    float adjustedLineSegmentedWidth = lineSegmentWidth * 0.99;
    float delta = (lineSegmentWidth- adjustedLineSegmentedWidth)/2.0;
    CGContextSetAlpha(ctx, 0.3);
    
    for(int i =0;i<self.segments;i++)
    {
        
        float x = margin +lineSegmentWidth*i +delta;
        CGContextMoveToPoint(ctx,x,  lineH);
        CGRect rect = CGRectMake(x, lineH, adjustedLineSegmentedWidth, segmentHeight);
        CGContextFillRect(ctx,rect);
        if(self.segments == 1){
            CGContextDrawImage(ctx, rect, _chocolate.CGImage);
        
        }else{
            CGContextDrawImage(ctx, rect, _segment.CGImage);
        
        }

        
        Segment * s= [[Segment alloc]init];
        s.frame = rect;
        s.selected = NO;
        self.segmentsArray[i]=s;
  
    }
    CGContextRestoreGState(ctx);
}


-(void)drawSegments{
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    //Draw Segments
    for(int i =0;i<self.segmentsArray.count;i++)
    {
        Segment * s =(Segment *)self.segmentsArray[i];
        if(s.selected){
            CGContextSetAlpha(ctx, 1);
            
            if(self.segments == 1){
                CGContextDrawImage(ctx, s.frame, _chocolate.CGImage);
                
            }else{
                CGContextDrawImage(ctx, s.frame, _segment.CGImage);
                
            }

            
            
        
        }
        else{
            CGContextSetAlpha(ctx, 0.5);
            if(self.segments == 1){
                CGContextDrawImage(ctx, s.frame, _chocolate.CGImage);
                
            }else{
                CGContextDrawImage(ctx, s.frame, _segment.CGImage);
                
            }

        }
        CGContextFillRect(ctx,s.frame);
        self.segmentsArray[i]=s;
    }
    
   
    CGContextRestoreGState(ctx);
}

-(float)getCurrentValue{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == 1"];
    
    NSArray *filteredArray = [self.segmentsArray filteredArrayUsingPredicate:predicate];
    id firstFoundObject = nil;
    if ([filteredArray count] > 0) {
        firstFoundObject = filteredArray[0];
    }
  //  NSLog(@"Filtered Array %@",filteredArray);
    float val = filteredArray.count*1.0/self.segmentsArray.count *1.0;
 //   NSLog(@"%f",val);
//    
//    for(int i =0;i<self.segmentsArray.count;i++)
//    {
//        Segment * s =(Segment *)self.segmentsArray[i];
//        if(s.selected){
//            
//        }
//    }
    return val;
}



@end
