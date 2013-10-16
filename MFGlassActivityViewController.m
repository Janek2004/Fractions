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
enum kFractionComparator {
    kEqual = 0,
    kLess = 1,
    kMore = 2
};
@interface MFGlassActivityViewController () {
    enum kFractionComparator comparator;
}
@property (weak, nonatomic) IBOutlet UIImageView *leftGlass;
@property (weak, nonatomic) IBOutlet UIImageView *rightGlass;
@property (weak, nonatomic) IBOutlet UIImageView *redoActivity;
@property (strong, nonatomic) NSMutableArray *leftGlassViews;
@property (strong, nonatomic) NSMutableArray *rightGlassViews;
@property (strong, nonatomic) IBOutlet UILabel *fractionView;
@property(strong,nonatomic) MFFraction *leftFraction;
@property(strong,nonatomic) MFFraction *rightFraction;
@property (weak, nonatomic) IBOutlet UILabel *cupLabel;
@property(strong,nonatomic) MFUtilities *utitilities;

@end

@implementation MFGlassActivityViewController
@synthesize currentFractions;
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
    self.leftGlassViews = [NSMutableArray new];
    self.rightGlassViews = [NSMutableArray new];
    [self.leftGlass addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftGlass:)]];
    [self.rightGlass addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightGlass:)]];
    [self.redoActivity addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startOver:)]];
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
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(recognizer.view.frame) + 10, CGRectGetMaxY(recognizer.view.frame) - CGRectGetHeight(recognizer.view.frame) / 6, CGRectGetWidth(recognizer.view.frame) - 20, CGRectGetHeight(recognizer.view.frame) / 6)];
            v.backgroundColor = [UIColor blueColor];
            v;
        });
        [self.view addSubview:fraction];
        [self.view insertSubview:fraction belowSubview:self.leftGlass];
        [self.leftGlassViews addObject:fraction];
    }
        
    else if(self.leftGlassViews.count < 6 && self.leftGlassViews.count != 0) {
        UIView *topView = [self.leftGlassViews lastObject];
        UIView *fraction = ({
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(topView.frame), CGRectGetMinY(topView.frame) - CGRectGetHeight(topView.frame), CGRectGetWidth(topView.frame), CGRectGetHeight(topView.frame))];
            v.backgroundColor = [UIColor blueColor];
            v;
        });
        [self.view addSubview:fraction];
        [self.view insertSubview:fraction belowSubview:self.leftGlass];
        [self.leftGlassViews addObject:fraction];
    }
}

-(void)tapRightGlass:(UITapGestureRecognizer *)recognizer {
    if(self.rightGlassViews.count == 0) {
        UIView *fraction = ({
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(recognizer.view.frame) + 10, CGRectGetMaxY(recognizer.view.frame) - CGRectGetHeight(recognizer.view.frame) / 6, CGRectGetWidth(recognizer.view.frame) - 20, CGRectGetHeight(recognizer.view.frame) / 6)];
            v.backgroundColor = [UIColor blueColor];
            v;
        });
        [self.view addSubview:fraction];
        [self.view insertSubview:fraction belowSubview:self.rightGlass];
        [self.rightGlassViews addObject:fraction];
    }
    
    else if(self.rightGlassViews.count < 6 && self.rightGlassViews.count != 0) {
        UIView *topView = [self.rightGlassViews lastObject];
        UIView *fraction = ({
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(topView.frame), CGRectGetMinY(topView.frame) - CGRectGetHeight(topView.frame), CGRectGetWidth(topView.frame), CGRectGetHeight(topView.frame))];
            v.backgroundColor = [UIColor blueColor];
            v;
        });
        [self.view addSubview:fraction];
        [self.view insertSubview:fraction belowSubview:self.rightGlass];
        [self.rightGlassViews addObject:fraction];
    }
}

//displays current fraction
-(void)setCurrentFractions:(NSArray *)fractions {
    NSLog(@"%d",fractions.count);
    if(fractions.count==2){
        self.leftFraction = fractions[0];
        self.rightFraction = fractions[1];
        
        self.fractionView.text = [NSString stringWithFormat:@"%@/%@", self.leftFraction.numerator, self.leftFraction.denominator];
        
    }

}

-(BOOL)checkAnswer{
    if(!_utitilities){
        _utitilities =[[MFUtilities alloc]init];
    }
    
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
-(void)reset {
    
}


@end
