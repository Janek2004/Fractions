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
#import "MFAppDelegate.h"
#import "DataManager.h"

@interface MFGlassActivityViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *leftGlass;
@property (weak, nonatomic) IBOutlet UIImageView *rightGlass;
@property (weak, nonatomic) IBOutlet UIImageView *redoActivity;

@property (strong, nonatomic) IBOutlet UILabel *fractionView;
@property (strong, nonatomic) IBOutlet UIButton *leftCupButton;
@property (strong, nonatomic) IBOutlet UIButton *middleCupButton;
@property (strong, nonatomic) IBOutlet UIButton *rightCupButton;

@property (strong, nonatomic) MFFraction * currentFraction; //target fraction
@property (strong, nonatomic) MFFraction * currentValue; // current user's answer

@property (strong, nonatomic) MFUtilities * utilities;
@property (strong, nonatomic) DataManager* dataManager;

@property (nonatomic,strong) NSArray *cupsArray;
@property (strong,nonatomic) UIView *leftWaterView;
@property (strong,nonatomic) UIView *rightWaterView;





//@property int numerator;
//@property int denominator;

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

-(void)viewDidAppear:(BOOL)animated{
 [self displayRightView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //_numerator = 1;
    //_denominator = 2;
    _utilities = [[MFUtilities alloc]init];
    _dataManager=[[DataManager alloc]init];
   
        NSLog(@"Current View DidLoad");
   

    
    [self.redoActivity addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startOver:)]];
    _cupsArray = [NSArray new];
}



-(void)startOver:(UITapGestureRecognizer *)recognizer {
    self.currentValue = NULL;
    [self displayLeftView];
}


-(void)displayLeftView{
   
    [self.leftWaterView removeFromSuperview];
    
    self.leftWaterView= ({
        UIView *v;
        //calculating height
        float k;
        
        if(!self.currentValue){
            v = [[UIView alloc]initWithFrame:CGRectZero];
        }
        else{
            k = self.currentValue.numerator.integerValue*1.0/ self.currentValue.denominator.integerValue*1.0;
        
        
        float h = CGRectGetHeight(self.leftGlass.frame);
        //adjusted height
        float dh = h * k;
        float y  = CGRectGetMinY(self.leftGlass.frame) + h -dh;
        
         v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.leftGlass.frame),
                                                            y,
                                                            CGRectGetWidth(self.leftGlass.frame), h * k)];
        }
        v.backgroundColor = [UIColor blueColor];
        v;
    });
    
    
    
    [UIView animateWithDuration:.227 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view addSubview:self.leftWaterView];
        
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.leftWaterView belowSubview:self.leftGlass];
        //[self.leftGlassViews addObject:self.leftWaterView];
    }];

}

-(void)displayRightView{
    [self.rightWaterView removeFromSuperview];
    
    self.rightWaterView=({
        
        //calculating height
        float k = self.currentFraction.numerator.integerValue*1.0/ self.currentFraction.denominator.integerValue*1.0;
        
        float h = CGRectGetHeight(self.rightGlass.frame);
        //adjusted height
        float dh = h * k;
        float y  = CGRectGetMinY(self.rightGlass.frame) + h -dh;
        

        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.rightGlass.frame),
                                                            y,
                                                            CGRectGetWidth(self.rightGlass.frame), dh)];
        
        v.backgroundColor = [UIColor blueColor];
        v;
    });
    
    
    [UIView animateWithDuration:.227 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view addSubview:self.rightWaterView];
        
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.rightWaterView belowSubview:self.rightGlass];
        
    }];
}
-(void)getFractions{
    // 1/10 2/10 3/10 4/10, 5/10 6/10 7/10 7/10
    //get denominator
    
    

}

//displays current fraction
-(void)setCurrentFractions:(NSArray *)currentFractions{

    _currentFraction = currentFractions[0];
    _fractionView.text= [NSString stringWithFormat:@"%@/%@",_currentFraction.numerator,_currentFraction.denominator];

    //reset the current value
    self.currentValue = nil;
    [self.leftWaterView removeFromSuperview];
    
    int d1 = _currentFraction.denominator.intValue;
    int n1 = _currentFraction.numerator.intValue;
    
    NSMutableArray * a = [NSMutableArray new];
    MFFraction * fr =[_dataManager getFractionInContext:nil];
    fr.numerator = [NSNumber numberWithInt:1];
    fr.denominator= [NSNumber numberWithInt:d1];

    [a addObject:fr];

    NSManagedObjectContext *context =   [(MFAppDelegate *) [[UIApplication sharedApplication]delegate]managedObjectContext];
    
    while (a.count!=3) {

        int n  =arc4random() %10 + 1;
        int d  =arc4random() %10 + 1;
        if((n1 *1.0/d1 != n*1.0/d) && n<d)
        {
            MFFraction * fr =[_dataManager getFractionInContext:context];
            fr.numerator = [NSNumber numberWithInt:n];
            fr.denominator= [NSNumber numberWithInt:d];
            
            [a addObject:fr];
        }
    }
    NSSortDescriptor * ds =[NSSortDescriptor sortDescriptorWithKey:@"denominator" ascending:YES];
    NSArray * b = [a sortedArrayUsingDescriptors:@[ds]];
   
    self.cupsArray = b;
    
    
   //set the values of the labels and so on
   [ self.leftCupButton setTitle:[NSString stringWithFormat:@"   %@/%@",[(MFFraction *)(self.cupsArray[0]) numerator],[(MFFraction *)self.cupsArray[0] denominator]] forState:UIControlStateNormal];
    
   [ self.middleCupButton setTitle: [NSString stringWithFormat:@"   %@/%@",[(MFFraction *)(self.cupsArray[1]) numerator],[(MFFraction *)self.cupsArray[1] denominator]] forState:UIControlStateNormal];
    
   [ self.rightCupButton setTitle: [NSString stringWithFormat:@"   %@/%@",[(MFFraction *)(self.cupsArray[2]) numerator],[(MFFraction *)self.cupsArray[2] denominator]] forState:UIControlStateNormal];
    
    [self displayRightView];
    [self displayLeftView];
}

-(void)checkAnswer:(void (^)(BOOL s, MFFraction * answer))completed{

    _currentFraction = [MFUtilities simplify:_currentFraction];
    NSLog(@"current value %@ target %@",_currentValue, _currentFraction);
    
    if([_utilities isEqual:_currentFraction and:_currentValue]){
        completed(YES,_currentValue);
    }
    else{
        completed(NO,_currentValue);
    }
    //reset values
    self.currentValue =nil;
    [self displayLeftView];
    
}

- (IBAction)pourCup:(id)sender {
    MFFraction * fr;
    
    if(sender == _leftCupButton){
        fr = self.cupsArray[0];
    }
    else if(sender == _middleCupButton){
        fr = self.cupsArray[1];
    }
    else if(sender == _rightCupButton){
        fr = self.cupsArray[2];
    }
    
    if(!self.currentValue)
    {
        self.currentValue = [_dataManager getFractionInContext:nil];
        self.currentValue.numerator = fr.numerator;
        self.currentValue.denominator= fr.denominator;
    }
    else{
        MFFraction * addition = [MFUtilities addFraction:self.currentValue to:fr];
            NSLog(@"Addition: %@ ",addition);
        if([MFUtilities getValueOfFraction:addition]>1)
        {
            NSLog(@"Overflowing");
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Fratio" message:@"The water will overflow!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
            return;
        }
        else{
            self.currentValue = addition;
        }
    }
    [self displayLeftView];
}

-(void)reset{
    NSLog(@"Empty");
}


@end
