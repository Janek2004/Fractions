//
//  MFGlassActivityViewController.m
//  MathFractions
//
//  Created by Terry Lewis II on 10/3/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MFGlassActivityViewController.h"
#import "MFFraction.h"
#import "MFUtilities.h"

#import "DataManager.h"

@interface MFGlassActivityViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *leftGlass;
@property (weak, nonatomic) IBOutlet UIImageView *rightGlass;
@property (weak, nonatomic) IBOutlet UIImageView *redoActivity;
@property (strong, nonatomic) NSMutableArray *leftGlassViews;

@property (strong, nonatomic) IBOutlet UILabel *fractionView;


@property (strong, nonatomic) IBOutlet UIButton *leftCupButton;
@property (strong, nonatomic) IBOutlet UIButton *middleCupButton;
@property (strong, nonatomic) IBOutlet UIButton *rightCupButton;

@property (strong, nonatomic) MFFraction * currentFraction;
@property (strong, nonatomic) MFUtilities * utilities;
@property (strong, nonatomic) DataManager* dataManager;

@property (nonatomic,strong) NSArray *cupsArray;

@property(strong,nonatomic) UIView *waterView;

@property int numerator;
@property int denominator;

- (IBAction)pourCup:(id)sender;

@end

@implementation MFGlassActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _numerator = 1;
    _denominator = 2;
    _utilities = [[MFUtilities alloc]init];
    _dataManager=[[DataManager alloc]init];

    self.leftGlassViews = [NSMutableArray new];
    [self.leftGlass addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftGlass:)]];
    
    [self.redoActivity addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startOver:)]];
    _cupsArray = [NSArray new];
}



-(void)startOver:(UITapGestureRecognizer *)recognizer {
    for(NSInteger i = self.leftGlassViews.count - 1; i >= 0; i--) {
        UIView *v = self.leftGlassViews[i];
        [UIView animateWithDuration:.227 delay:((self.leftGlassViews.count - 1 - i) * .1) options:UIViewAnimationOptionCurveLinear animations:^{
            v.alpha = 0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }
    [self.leftGlassViews removeAllObjects];
//    for(NSInteger i = self.rightGlassViews.count - 1; i >= 0; i--) {
//        UIView *v = self.rightGlassViews[i];
//        [UIView animateWithDuration:.227 delay:((self.rightGlassViews.count - 1 - i) * .1) options:UIViewAnimationOptionCurveLinear animations:^{
//            v.alpha = 0;
//        } completion:^(BOOL finished) {
//            [v removeFromSuperview];
//        }];
//    }
//    [self.rightGlassViews removeAllObjects];
}
-(void)tapLeftGlass:(UITapGestureRecognizer *)recognizer {
    if(self.leftGlassViews.count == 0) {
        UIView *fraction = ({
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(recognizer.view.frame) + 10, -15 + CGRectGetMaxY(recognizer.view.frame) - (CGRectGetHeight(recognizer.view.frame)-15) / _denominator, CGRectGetWidth(recognizer.view.frame) - 20, CGRectGetHeight(recognizer.view.frame) / _denominator)];
            v.backgroundColor = [UIColor blueColor];
            v;
        });
        [self.view addSubview:fraction];
        [self.view insertSubview:fraction belowSubview:self.leftGlass];
        [self.leftGlassViews addObject:fraction];
    }
        
    else if(self.leftGlassViews.count < _denominator && self.leftGlassViews.count != 0) {
        UIView *topView = [self.leftGlassViews lastObject];
        UIView *fraction = ({
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(topView.frame), CGRectGetMinY(topView.frame) - CGRectGetHeight(topView.frame), CGRectGetWidth(topView.frame), CGRectGetHeight(topView.frame))];
            v.backgroundColor = [UIColor blueColor];
            v.layer.borderColor = [[UIColor darkGrayColor]CGColor];
            v.layer.borderWidth = 1.0;
            v;
        });
        [self.view addSubview:fraction];
        [self.view insertSubview:fraction belowSubview:self.leftGlass];
        [self.leftGlassViews addObject:fraction];
    }
}

//displays current fraction
-(void)setCurrentFractions:(NSArray *)currentFractions{
    _currentFraction = currentFractions[0];
    _fractionView.text= [NSString stringWithFormat:@"%@/%@",_currentFraction.numerator,_currentFraction.denominator];
    
    //that's the one that they are looking for
    //get denonominator
    
    int d1 = _currentFraction.denominator.intValue;
    int n1 = _currentFraction.denominator.intValue;

    int k = 10/d1; //maximum factor
    
    int l =  arc4random()%k+ 1;
    NSMutableArray * a = [NSMutableArray new];
    MFFraction * fr =[_dataManager getFraction];
    fr.numerator = [NSNumber numberWithInt:(n1* l) ];
    fr.denominator= [NSNumber numberWithInt:(d1*l)];

    [a addObject:fr];

    
    
    while (a.count!=3) {

        int n  =arc4random() %10 + 1;
        int d  =arc4random() %10 + 1;
        if(n1/d1 != n/d && n<d)
        {
            MFFraction * fr =[_dataManager getFraction];
            fr.numerator = [NSNumber numberWithInt:n];
            fr.denominator= [NSNumber numberWithInt:d];
            
            [a addObject:fr];
        }
    }
    NSSortDescriptor * ds =[NSSortDescriptor sortDescriptorWithKey:@"numerator" ascending:YES];
    NSArray * b = [a sortedArrayUsingDescriptors:@[ds]];
   
    self.cupsArray = b;
   //set the values of the labels and so on
   [ self.leftCupButton setTitle:[NSString stringWithFormat:@"   %@/%@",[(MFFraction *)(self.cupsArray[0]) numerator],[(MFFraction *)self.cupsArray[0] denominator]] forState:UIControlStateNormal];
    
   [ self.middleCupButton setTitle: [NSString stringWithFormat:@"   %@/%@",[(MFFraction *)(self.cupsArray[1]) numerator],[(MFFraction *)self.cupsArray[1] denominator]] forState:UIControlStateNormal];
    
   [ self.rightCupButton setTitle: [NSString stringWithFormat:@"   %@/%@",[(MFFraction *)(self.cupsArray[2]) numerator],[(MFFraction *)self.cupsArray[2] denominator]] forState:UIControlStateNormal];

    
}

-(void)checkAnswer:(void (^)(BOOL s))completed{
    //curent value
    MFFraction * fraction = [_dataManager getFraction];
  //   fraction.numerator =[NSNumber numberWithInt:self.leftGlassViews.count];
  //  fraction.denominator =[NSNumber numberWithInt:self.denominator];
    fraction.numerator = [NSNumber numberWithInt:self.numerator];
    fraction.denominator = [NSNumber numberWithInt:self.denominator];
    fraction =  [_utilities simplify:fraction];
    _currentFraction = [_utilities simplify:_currentFraction];
    NSLog(@"%@ %@",fraction, _currentFraction);
    
    if([_utilities isEqual:_currentFraction and:fraction]){
      
        completed(YES);
    }
    else{
        completed(NO);
    }
}

- (IBAction)pourCup:(id)sender {
    MFFraction * fr;
    
    if(sender == _leftCupButton){
        fr = self.cupsArray[0];
    }
    if(sender == _middleCupButton){
        fr = self.cupsArray[1];
    }
    if(sender == _rightCupButton){
        fr = self.cupsArray[2];
    }
    
    _numerator = fr.numerator.integerValue;
    _denominator = fr.denominator.integerValue;
    
    
    [_waterView removeFromSuperview];
    
    _waterView= ({

        //calculating height
        float k = fr.numerator.integerValue*1.0/ fr.denominator.integerValue*1.0;
        float h = CGRectGetHeight(self.leftGlass.frame)-25;
        //adjusted height
        float dh = h * k;
        float y  = CGRectGetMinY(self.leftGlass.frame) + h -dh;
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.leftGlass.frame) + 10,
                                                          y,
                                                            CGRectGetWidth(self.leftGlass.frame)-20, dh)];
        
        v.backgroundColor = [UIColor blueColor];
        v;
    });
    [UIView animateWithDuration:.227 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view addSubview:_waterView];
        
    } completion:^(BOOL finished) {
        [self.view insertSubview:_waterView belowSubview:self.leftGlass];
        [self.leftGlassViews addObject:_waterView];
    }];
}

@end
