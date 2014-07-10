//
//  MFCicleViewController.m
//  Fractio
//
//  Created by Janusz Chudzynski on 7/1/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//
#import "MFAppDelegate.h"
#import "MFCicleViewController.h"
#import "MFFraction.h"
#import "NumberLinePieceView.h"
#import "MFUtilities.h"
#import "JMCCircle.h"



typedef   void (^checkAnswerBlock)(BOOL s, MFFraction * answer);

@interface MFCicleViewController ()
 {
    
     int numerator;
     int denominator;
 }


 @property(nonatomic,strong) MFFraction * fraction;
 @property(nonatomic,strong) MFFraction * currentFraction;
 @property(nonatomic,strong) UILabel * fractionLabel;
 @property(nonatomic,strong) UITapGestureRecognizer * tapRecognizer;
 @property(nonatomic,strong) NSMutableArray * piecesArray;
 @property(nonatomic,strong) MFUtilities * utilities;
 @property (nonatomic, copy) checkAnswerBlock completionBlock;

@end

@implementation MFCicleViewController

-(void)setCurrentFractions:(NSArray *)currentFractions{
    [self reset];
    
    MFFraction * currentFraction = currentFractions[0];
    _currentFraction = currentFraction;
    
    //self.fractionLabel.text =[NSString stringWithFormat:@"%@/%@",_currentFraction.numerator, _currentFraction.denominator];

    [self drawCircle];
    

}

-(void)checkAnswer:(void (^)(BOOL s, MFFraction * answer))completed;{
    self.completionBlock = [completed copy];
    
    NumberLinePieceView * p =_piecesArray[0];
    MFFraction * mf2 = p.getCurrentFraction;
    MFFraction * mf1 = self.currentFraction;
    if(self.completionBlock){
        self.completionBlock([_utilities isEqual:mf2 and:mf1], mf2);
    }
}

-(void)reset;{
    for(int i = 0; i<_piecesArray.count;i++){
        [_piecesArray[i] removeFromSuperview];
    }
    
    
    [self setUpView];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)inCoder;{
    self = [super initWithCoder:inCoder];
    if (self) {
        //[self setUpView];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //[self setUpView];
   // anim_count = 0;
}

-(void)setUpView{
    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    _fraction = [NSEntityDescription insertNewObjectForEntityForName:@"MFFraction" inManagedObjectContext:context];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    _piecesArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    CGRect frame = CGRectMake(600,255, 400,100);
    NumberLinePieceView *nl =[[ NumberLinePieceView alloc]initWithFrame:frame];
    [_piecesArray addObject:nl];
    
   
    _utilities = [[MFUtilities alloc]init];
    [self drawPieces];
    [self drawCircle];
}

-(void)drawCircle{
    
    float v = [MFUtilities getValueOfFraction:self.currentFraction];
    int max = 360 * v;
    int parts = 360.0/self.currentFraction.denominator.floatValue;
    
    
    JMCCircle * circle = [[JMCCircle alloc]initWithFrame:CGRectMake(30, 250, 400, 400)];
    [self.view addSubview:circle];
    [circle setStart:1 step:parts endDegree:max];
    
}

-(void)drawPieces{
    float h = (CGRectGetHeight(self.view.frame )- 55 -(_piecesArray.count * 10))/_piecesArray.count;
    if(h>100){
        h =80;
    }

    for(int i = 0; i<_piecesArray.count;i++){
        [_piecesArray[i] removeFromSuperview];
        // calculate frame
        float y = 355 + 10*i + h *i;
        
        float w = CGRectGetWidth([( NumberLinePieceView*)_piecesArray[0] frame]);
        float x = CGRectGetMinX([( NumberLinePieceView*)_piecesArray[0] frame]);;
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
