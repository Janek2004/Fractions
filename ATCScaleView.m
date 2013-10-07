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
//#import "MFFractionView.h"
#import "MFUtilities.h"

#define RectSize 25
#define WIDTH 0.7
#define alpha_interval 0.5

enum kFractionComparator {
    kEqual = 0,
    kLess = 1,
    kMore = 2
};

@interface ATCScaleView()
{
    CGPoint leftOrigin;
    CGPoint rightOrigin;
    CGPoint touchOrigin;
    float scaleWidth;
    float alpha;
    float armHeight;
    enum kFractionComparator comparator;
}

@property(nonatomic,strong) UIPanGestureRecognizer * upGesture;
@property(nonatomic,strong) IBOutlet UIImageView * leftArmImageView;
@property(nonatomic,strong) IBOutlet UIImageView * rightArmImageView;
@property(nonatomic,strong) MFFraction * leftFraction;
@property(nonatomic,strong) MFFraction * rightFraction;

@property(nonatomic,strong) MFUtilities *utitilities;
@property (strong, nonatomic) IBOutlet UILabel *leftFractionLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightFractionLabel;

@property (strong, nonatomic) IBOutlet UIView *leftArm;
@property (strong, nonatomic) IBOutlet UIView *rightArm;
@property (strong, nonatomic) IBOutlet UILabel *labelSign;

@end



@implementation ATCScaleView



-(BOOL)checkAnswer{
    
    
    if([_utitilities getValueOfFraction: self.leftFraction] == [_utitilities getValueOfFraction: self.rightFraction] && comparator == kEqual)
    {
        return YES;
    }
    if([_utitilities getValueOfFraction: self.leftFraction] < [_utitilities getValueOfFraction: self.rightFraction] && comparator == kLess)
    {
        return YES;
    }
    if([_utitilities getValueOfFraction: self.leftFraction] > [_utitilities getValueOfFraction: self.rightFraction] && comparator == kMore)
    {
             return YES;
    }
    
    
    return NO;
}


- (id)initWithCoder:(NSCoder *)inCoder;{
    self = [super initWithCoder:inCoder];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    //get width
    float width = WIDTH * self.frame.size.width;
    float x1 = self.center.x - width/2.0;
    float x2 = self.center.x + width/2.0;
    alpha = 0;
    leftOrigin = CGPointMake(x1, self.center.y);
    rightOrigin = CGPointMake(x2, self.center.y);
    scaleWidth = width;
    armHeight = CGRectGetHeight(self.leftArm.frame);
    
    if(!_upGesture){
    _upGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(upGestureTriggered:)];
    _upGesture.minimumNumberOfTouches =1;
    _upGesture.maximumNumberOfTouches =1;
    [self addGestureRecognizer:_upGesture];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        _utitilities = [[MFUtilities alloc]init];
    }
    return self;
}

-(void)reset{
    [self setUpView];
    [self drawSign];
}



-(void)upGestureTriggered:(UIPanGestureRecognizer *)recognizer{
    CGPoint  touch = [recognizer locationInView:self];
    // CGPoint  velocity = [recognizer velocityInView:self];
    CGPoint lcenter = self.leftArm.center;
    CGPoint rcenter = self.rightArm.center;
    
    CGRect  dl = self.leftArm.frame;
    CGRect  dr = self.rightArm.frame;
    
    float delta;
    
    
    if(CGRectContainsPoint(self.leftArm.frame, touch)){
        //move up or down and do opposite for other arm
        delta = lcenter.y - touch.y;
        
        lcenter.y = touch.y;
        rcenter.y = rcenter.y + delta;
       
    
    }
    if(CGRectContainsPoint(self.rightArm.frame, touch)){
        //move up or down and do opposite for other arm
        delta = rcenter.y - touch.y;
        rcenter.y = touch.y;
        lcenter.y = lcenter.y + delta;
    
    }
    
    self.leftArm.center = lcenter;
    self.rightArm.center = rcenter;
    

    if(CGRectGetMinY(_leftArm.frame)<= (CGRectGetHeight(self.bounds)- CGRectGetHeight(self.leftArm.bounds))||CGRectGetMinY(_rightArm.frame)<= (CGRectGetHeight(self.bounds)- CGRectGetHeight(self.rightArm.bounds))){
        self.leftArm.frame= dl;
        self.rightArm.frame= dr;
        
        return;
    }
    
    
    alpha =  self.leftArm.center.y -  self.rightArm.center.y;
    self.leftArm.center = lcenter;
    self.rightArm.center = rcenter;
    
     [self drawSign];
}
-(void)setCurrentFractions:(NSArray *)currentFractions{
  
    
    if(currentFractions.count==2){
        self.leftFraction = currentFractions[0];
        self.rightFraction = currentFractions[1];
        
        self.leftFractionLabel.text = [NSString stringWithFormat:@"%@/%@",self.leftFraction.numerator,self.leftFraction.denominator];
        self.rightFractionLabel.text = [NSString stringWithFormat:@"%@/%@",self.rightFraction.numerator,self.rightFraction.denominator];
        
    }
    [self drawSign];
}



-(void)drawFractions{
   
        
}

-(void)drawSign{
    if(alpha >=-15 && alpha <=15){
     self.labelSign.text = @"=";
     comparator =kEqual;
        
    }
    
    else if(alpha <-15 ){
         self.labelSign.text = @">";
        comparator =kMore;
    }
    
    else if(alpha >15 ){
        comparator =kLess;
         self.labelSign.text = @"<";
    }
    
}



@end
