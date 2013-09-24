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

#import "NumberLineView.h"
#import "NumberLinePieceView.h"
#import "Segment.h"
#import "MFFraction.h"
#import "MFFractionView.h"


@interface NumberLineView()
{
    int numerator;
    int denominator;
    MFFraction *fraction;
}

@property (nonatomic,strong) UIBezierPath* ovalPath;
@property (nonatomic,strong) UITapGestureRecognizer * tapRecognizer;
@property (nonatomic,strong) NSMutableArray * piecesArray;
@property (nonatomic,strong) UIButton * addButton;
//@property (nonatomic,strong) UILabel * fractionLabel;
@property (nonatomic,strong) MFFractionView * fractionView;




@property int pieces;
@end

#define MAX_NUM_PIECES  10
@implementation NumberLineView
-(void)reset{
    for(UIView * v in _piecesArray){
        [v removeFromSuperview];
    
    }
    [_piecesArray removeAllObjects];
    float w = 0.5 * CGRectGetWidth(self.frame);
    float x =CGRectGetWidth(self.frame) - w -w/2.0;
    
    CGRect frame = CGRectMake(x,55, w,100);
    NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:frame];
    [_piecesArray addObject:nl];
  [self drawPieces];
    
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        fraction = [MFFraction new];
        
        _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        _piecesArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        float w = 0.5 * CGRectGetWidth(self.frame);
        float x =CGRectGetWidth(self.frame) - w -w/2.0;
        

        _fractionView = [[MFFractionView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self addSubview:_fractionView];
                         
                          
        CGRect frame = CGRectMake(x,55, w,100);
        NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:frame];
        [_piecesArray addObject:nl];
        
        CGRect btnframe = CGRectMake(5,5,50,50);
        _addButton=[[UIButton alloc]initWithFrame:btnframe];
        [_addButton addTarget:self action:@selector(addPiece) forControlEvents:UIControlEventTouchUpInside];
        
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor redColor]];
        numerator = 0;
        denominator = 0;
        
        [self drawPieces];
        [self addSubview:_addButton];
    }
    return self;
}

-(void)setCurrentFraction:(MFFraction *)currentFraction{
    _currentFraction = currentFraction;
    _fractionView.fraction = currentFraction;
    [_fractionView setNeedsDisplay];
    
}

-(void)addPiece{
    if(_piecesArray.count < MAX_NUM_PIECES){
       NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:CGRectZero];
      [_piecesArray addObject:nl];
      [self drawPieces];
    }
}

// Only override drawRect: if you perform custom drawing.
/* An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self drawPlus];
    [self drawPieces];
    
}
*/
 
-(void)tapGesture:(UITapGestureRecognizer*)r{
    CGPoint point = [r locationInView:self];
    
    if(CGRectContainsPoint(_ovalPath.bounds, point)){
        NSLog(@"We should add more segments");
        
        
    }
}

-(void)drawPieces{
    //calculate dimensions
    //add as subview
    float h = (CGRectGetHeight(self.frame )- 55 -(_piecesArray.count * 10))/_piecesArray.count;
    if(h>100){
        h =80;
    }

    for(int i = 0; i<_piecesArray.count;i++){
        [_piecesArray[i] removeFromSuperview];
        // calculate frame
        float y = 55 + 10*i + h *i;
        
        float w = 0.5 * CGRectGetWidth(self.frame);
        float x =CGRectGetWidth(self.frame) - w -w/2.0;
        CGRect frame = CGRectMake(x,y, w, h);
        
        UIView * v = _piecesArray[i];
        v.frame = frame;
   
        [self addSubview:v];
        [self setNeedsDisplay];
    }
}

-(BOOL)checkAnswer{
    MFFraction * mf = [self calculateScore];
    MFFraction * mf1 = self.currentFraction;

    return [mf isEqual: mf1];
}


-(MFFraction *)calculateScore{
    numerator = 0;
    denominator = 0;
    
    for(int i = 0; i<_piecesArray.count;i++){
        NumberLinePieceView * p =_piecesArray[i];
        int new_numerator = 0;
        int new_denominator = p.segmentsArray.count;
        for (int j=0; j<p.segmentsArray.count;j++){
            if([(Segment*) p.segmentsArray[j] selected])
            {
                new_numerator ++;
            }
        }
        
        if(denominator == 0 && new_denominator !=0 && new_numerator != 0)
        {
           numerator = new_numerator;
           denominator =new_denominator;

            //break;
        }
        else if(new_denominator!=0 && denominator !=0)
        {
            numerator = numerator  * new_denominator + new_numerator * denominator;
            denominator = new_denominator * denominator;
            
        }
    }
    fraction.numerator = numerator;
    fraction.denominator = denominator;
    fraction =  [self simplify:fraction];
    
    return fraction;
}


-(MFFraction *)simplify:(MFFraction *)_fraction{
    if(_fraction.denominator==0 && _fraction.numerator ==0)
    {
        return _fraction;
    }
    if(_fraction.denominator%5==0 &&_fraction.numerator %5==0)
    {
        _fraction.denominator = _fraction.denominator/5;
        _fraction.numerator = _fraction.numerator/5;
        [self simplify:_fraction];
    }
    if(_fraction.denominator%2==0 &&_fraction.numerator %2==0)
    {
        _fraction.denominator =_fraction.denominator/2;
        _fraction.numerator = _fraction.numerator/2;
        [self simplify:_fraction];
    }
    return _fraction;
    
}



@end
