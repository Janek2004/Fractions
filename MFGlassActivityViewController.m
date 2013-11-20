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
@property (strong, nonatomic) NSMutableArray *rightGlassViews;
@property (strong, nonatomic) IBOutlet UILabel *fractionView;
@property (strong, nonatomic) IBOutlet UIImageView *cupView;
@property (strong, nonatomic) IBOutlet UILabel *cupLabel;
@property (strong, nonatomic) MFFraction * currentFraction;
@property (strong, nonatomic) MFUtilities * utilities;

@property (strong, nonatomic) DataManager* dataManager;

@property int numerator;
@property int denominator;

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
    [self displayCupLabel:_denominator];
    self.leftGlassViews = [NSMutableArray new];
    self.rightGlassViews = [NSMutableArray new];
    [self.leftGlass addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftGlass:)]];
    
    [self.cupView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCup:)]];
    
    [self.redoActivity addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startOver:)]];
}

-(void)displayCupLabel:(int)denominator{
    NSString * s = [NSString stringWithFormat:@"1/%d",denominator];
    self.cupLabel.text  = s;
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
    for(NSInteger i = self.rightGlassViews.count - 1; i >= 0; i--) {
        UIView *v = self.rightGlassViews[i];
        [UIView animateWithDuration:.227 delay:((self.rightGlassViews.count - 1 - i) * .1) options:UIViewAnimationOptionCurveLinear animations:^{
            v.alpha = 0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }
    [self.rightGlassViews removeAllObjects];
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
-(void)tapCup:(UITapGestureRecognizer *)recognizer {
    _denominator ++;
    if(_denominator>10){
        _denominator = 2;
    
    }
    
    [self displayCupLabel:_denominator];
}

//displays current fraction
-(void)setCurrentFractions:(NSArray *)currentFractions{
   _currentFraction = currentFractions[0];
    _fractionView.text= [NSString stringWithFormat:@"%@/%@",_currentFraction.numerator,_currentFraction.denominator];
}

-(BOOL)checkAnswer:(void (^)(BOOL s))completed{
    //curent value
    MFFraction * fraction = [_dataManager getFraction];
  
    fraction.numerator =[NSNumber numberWithInt:self.leftGlassViews.count];
    fraction.denominator =[NSNumber numberWithInt:self.denominator];

    if([_utilities isEqual:_currentFraction and:fraction]){
        return YES;
        completed(YES);
    }
    completed(NO);
    
    return NO;
}



@end
