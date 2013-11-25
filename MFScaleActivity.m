//
//  MFScaleActivity.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 11/20/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MFScaleActivity.h"
#import "MFFraction.h"
#import "MFUtilities.h"

#define RectSize 25
#define WIDTH 0.7
#define alpha_interval 0.5

enum kFractionComparator {
    kEqual = 0,
    kLess = 1,
    kMore = 2
};


@interface MFScaleActivity ()
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

@property(nonatomic,strong) MFFraction * leftFraction;
@property(nonatomic,strong) MFFraction * rightFraction;

@property(nonatomic,strong) MFUtilities *utitilities;
@property (strong, nonatomic) IBOutlet UILabel *leftFractionLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightFractionLabel;

@property (strong, nonatomic) IBOutlet UIView *leftArm;
@property (strong, nonatomic) IBOutlet UIView *rightArm;
@property (strong, nonatomic) IBOutlet UILabel *labelSign;

@end






@implementation MFScaleActivity
-(void)checkAnswer:(void (^)(BOOL s))completed{
    if(!_utitilities){
        _utitilities =[[MFUtilities alloc]init];
    }
    
    if([MFUtilities getValueOfFraction: self.leftFraction] == [MFUtilities getValueOfFraction: self.rightFraction] && comparator == kEqual)
    {
        completed(YES);
 
    }
    else if([MFUtilities getValueOfFraction: self.leftFraction] < [MFUtilities getValueOfFraction: self.rightFraction] && comparator == kLess)
    {
        completed(YES);
 
    }
    else if([MFUtilities getValueOfFraction: self.leftFraction] > [MFUtilities getValueOfFraction: self.rightFraction] && comparator == kMore)
    {
        completed(YES);
 
    }
    else{
        completed(NO);
    }

}




-(void)setUpView{
    // Initialization code
    self.view.backgroundColor = [UIColor whiteColor];
    //get width
    float width = WIDTH * self.view.frame.size.width;
    float x1 = self.view.center.x - width/2.0;
    float x2 = self.view.center.x + width/2.0;
    alpha = 0;
    leftOrigin = CGPointMake(x1, self.view.center.y);
    rightOrigin = CGPointMake(x2, self.view.center.y);
    scaleWidth = width;
    armHeight = CGRectGetHeight(self.leftArm.frame);
    
    if(!_upGesture){
        _upGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(upGestureTriggered:)];
        _upGesture.minimumNumberOfTouches =1;
        _upGesture.maximumNumberOfTouches =1;
        [self.view addGestureRecognizer:_upGesture];
    }
}




-(void)reset{
    [self setUpView];
    [self drawSign];
}


-(void)animateScale{
    
    CGPoint lcenter = self.leftArm.center;
    CGPoint rcenter = self.rightArm.center;
    
  //  CGRect  dl = self.leftArm.frame;
  //  CGRect  dr = self.rightArm.frame;

    //alpha =  self.leftArm.center.y -  self.rightArm.center.y;
   
    
//    [UIView animateWithDuration:2 animations:^{
//        self.leftArm.center = lcenter;
//        self.rightArm.center = rcenter;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateKeyframesWithDuration:1.4 delay:0 options:UIViewKeyframeAnimationOptionAutoreverse animations:^{

        CGPoint l = lcenter;
        CGPoint r = rcenter;
         float delta = 25;
        l.y = lcenter.y-delta;
        r.y = rcenter.y + delta;

        
        self.leftArm.center = l;
        self.rightArm.center = r;
        _labelSign.text = @"<";
        
              l.y = lcenter.y+2*delta;
        r.y = rcenter.y -2 * delta;
        self.leftArm.center = l;
        self.rightArm.center = r;
        self.labelSign.text = @"=";
        
        l.y = lcenter.y-delta;
        r.y = rcenter.y + delta;
        self.leftArm.center = l;
        self.rightArm.center = r;
        self.labelSign.text = @">";
        
    } completion:^(BOOL finished) {
        self.leftArm.center = lcenter;
        self.rightArm.center = rcenter;
 
    }];

    
    [self drawSign];


}



-(void)upGestureTriggered:(UIPanGestureRecognizer *)recognizer{
    CGPoint  touch = [recognizer locationInView:self.view];
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
    
    
    if(CGRectGetMinY(_leftArm.frame)<= (CGRectGetHeight(self.view.bounds)- CGRectGetHeight(self.leftArm.bounds))||CGRectGetMinY(_rightArm.frame)<= (CGRectGetHeight(self.view.bounds)- CGRectGetHeight(self.rightArm.bounds))){
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




-(void)drawSign{
    if(alpha >=-15 && alpha <=15){
        self.labelSign.text = @"=";
        comparator =kEqual;
        
    }
    
    else if(alpha <-15 ){
        self.labelSign.text = @"<";
        comparator =kLess;
    }
    
    else if(alpha >15 ){
        
        self.labelSign.text = @">";
        comparator =kMore;
        
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
    _utitilities = [[MFUtilities alloc]init];

}

-(void)viewDidAppear:(BOOL)animated{
    [self animateScale];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
