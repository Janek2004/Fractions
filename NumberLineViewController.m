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
#import "MFFraction.h"
#import "MFUtilities.h"
#import "MFAppDelegate.h"
#import "NumberLineViewController.h"

typedef   void (^checkAnswerBlock)(BOOL s, MFFraction * answer);

@interface NumberLineViewController()
{
    int numerator;
    int denominator;
    MFFraction *fraction;
    int anim_count;
  
}

@property (nonatomic,strong) UIBezierPath* ovalPath;
@property (nonatomic,strong) UITapGestureRecognizer * tapRecognizer;
@property (nonatomic,strong) NSMutableArray * piecesArray;
@property (nonatomic,strong) UIButton * addButton;

@property(nonatomic,strong) MFFraction * currentFraction;
@property (nonatomic,strong) MFUtilities * utilities;

@property (strong, nonatomic) IBOutlet UILabel *fractionLabel;
@property (strong, nonatomic)  UILabel * lbl;
@property (nonatomic, copy) checkAnswerBlock completionBlock;

@property int pieces;
@end

#define MAX_NUM_PIECES  10
#define PIECE_WIDTH 600
#define PIECE_HEIGHT  100

@implementation NumberLineViewController
-(void)reset{
    for(UIView * v in _piecesArray){
        [v removeFromSuperview];
        
    }
    [_piecesArray removeAllObjects];
    float w = PIECE_WIDTH;
    
    float x = [self getX];
    CGRect frame = CGRectMake(x,55, w,100);
    NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:frame];
    [_piecesArray addObject:nl];
    [self drawPieces];
    
}

- (id)initWithCoder:(NSCoder *)inCoder;{
    self = [super initWithCoder:inCoder];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    anim_count = 0;
}

-(void)setUpView{
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    fraction = [NSEntityDescription insertNewObjectForEntityForName:@"MFFraction" inManagedObjectContext:context];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    _piecesArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    float w = PIECE_WIDTH;
    float x =[self getX];
    
    CGRect frame = CGRectMake(x,55, w,100);
    NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:frame];
    [_piecesArray addObject:nl];
    
    CGRect btnframe = CGRectMake(5,25,220,30);
    _addButton=[[UIButton alloc]initWithFrame:btnframe];
    [_addButton addTarget:self action:@selector(addPiece) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setTitle:@"Add Candy Bar" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [_addButton setBackgroundColor:[UIColor redColor]];
    _addButton.layer.cornerRadius =5;
    numerator = 0;
    denominator = 0;
    
    _utilities = [[MFUtilities alloc]init];
    
    [self drawPieces];
    [self.view addSubview:_addButton];
    
}



-(void)setCurrentFractions:(NSArray *)currentFractions{
    [self reset];

    MFFraction * currentFraction = currentFractions[0];
    _currentFraction = currentFraction;
    self.fractionLabel.text =[NSString stringWithFormat:@"%@/%@",_currentFraction.numerator, _currentFraction.denominator];
    
}

-(void)addPiece{
    if(_piecesArray.count < MAX_NUM_PIECES){
        NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:CGRectZero];
        [_piecesArray addObject:nl];
        [self drawPieces];
    }
}


-(void)tapGesture:(UITapGestureRecognizer*)r{
    CGPoint point = [r locationInView:self.view];
    
    if(CGRectContainsPoint(_ovalPath.bounds, point)){
        NSLog(@"We should add more segments");
        
        
    }
}

-(int)getX{
    float x= 40;
    return x;
}


-(void)drawPieces{
    //calculate dimensions
    //add as subview
    float h = (CGRectGetHeight(self.view.frame )- 55 -(_piecesArray.count * 10))/_piecesArray.count;
    if(h>100){
        h =80;
    }
    
    for(int i = 0; i<_piecesArray.count;i++){
        [_piecesArray[i] removeFromSuperview];
        // calculate frame
        float y = 55 + 10*i + h *i;
        
        float w = PIECE_WIDTH;
        //float x =CGRectGetWidth(self.frame) - w -w/2.0;
        float x = [self getX];
        
        CGRect frame = CGRectMake(x,y, w, h);
        
        [UIView animateWithDuration:0.2

                         animations:^{
        
                             UIView * v = _piecesArray[i];
                             v.frame = frame;
                             
                             [self.view addSubview:v];
    }];
;
    }
}

-(void)animateFeedback:(NSTimer *)timer{
    NSLog(@"timer");
    if(!_lbl){
        _lbl = [[UILabel alloc]initWithFrame:CGRectMake(40,40,100,100)];
    }
    [self.view addSubview:_lbl];
    _lbl.backgroundColor = [UIColor clearColor];
    _lbl.font = [UIFont fontWithName:@"Arial" size:40];
    _lbl.textColor = [UIColor whiteColor];
    
    if(anim_count == _piecesArray.count){
        MFFraction * mf = [self calculateScore];
        MFFraction * mf1 = self.currentFraction;
        if([timer isValid])        [timer invalidate];

        self.completionBlock( [_utilities isEqual:mf and:mf1],mf);
        [self.piecesArray removeAllObjects];
        [self drawPieces];
        
        
        [_lbl removeFromSuperview];
        
    }else{
       NumberLinePieceView * s= _piecesArray[anim_count];
        _lbl.text = [NSString stringWithFormat:@"%@/%@",s.getCurrentFraction.numerator,s.getCurrentFraction.denominator];
        _lbl.frame = CGRectOffset(s.frame, 0, 30);
         [UIView animateWithDuration:1
                         animations:^{
                             s.alpha = 0;
                         }];
        
        
        anim_count ++;
    }
}

-(void)checkAnswer:(void (^)(BOOL s, MFFraction * answer))completed;{
    self.completionBlock = [completed copy];
    anim_count = 0;
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(animateFeedback:) userInfo:nil repeats:YES];
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
            
        }
        else if(new_denominator!=0 && denominator !=0)
        {
            numerator = numerator  * new_denominator + new_numerator * denominator;
            denominator = new_denominator * denominator;

        }
    }
    
    if(numerator ==0 &&denominator ==0){
        return nil;
    }
    fraction.numerator = [NSNumber numberWithInt: numerator];
    fraction.denominator = [NSNumber numberWithInt:denominator];
    
    fraction =  [MFUtilities simplify:fraction];
    
    
    return fraction;
}





@end
