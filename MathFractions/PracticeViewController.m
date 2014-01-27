//
//  PracticeViewController.m
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


#import "MFUtilities.h"
#import "UIBAlertView.h"
#import "DataManager.h"
#import "MFManager.h"
#import "MFFraction.h"
#import "MFActivity.h"
#import "MFPracticeRequiredMethods.h"
#import "MFAttempt.h"

#import "MFGlassActivityViewController.h"
#import "PracticeViewController.h"
#import "NumberLineViewController.h"
#import "MFScaleActivity.h"

#import "SoundHelper.h"




@interface PracticeViewController ()
@property (nonatomic,strong) MFGlassActivityViewController *glassVC;
@property (nonatomic,strong) MFScaleActivity * scaleVC;
@property (nonatomic) BOOL  introShown;
@property (nonatomic,strong) MFUtilities * utilities;
@property (nonatomic,strong) DataManager * dataManager;
@property (nonatomic,strong) MFManager * manager;
@property (nonatomic,strong) MFActivity *currentActivity;



@property (strong, nonatomic) IBOutlet UIView *activityContainer;
@property int currentQuestionIndex;
@property int wrongCount;
@property (strong, nonatomic) IBOutlet UIView *feedbackView;
@property (strong, nonatomic) IBOutlet UIView *gameOver;
@property (strong, nonatomic) IBOutlet UIView *hintView;
@property (strong, nonatomic) NumberLineViewController *numberLineVC;
@property (strong, nonatomic) UIViewController * currentVC;

@property (strong, nonatomic) IBOutlet UIImageView *feedbackImageView;
@property (strong, nonatomic) IBOutlet UILabel *fedbackLabel;
@property (strong,nonatomic) NSMutableArray *questionsSet;
@property BOOL right;

@property (nonatomic,strong) SoundHelper * soundHelper;

@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *hintButton;
@property (strong, nonatomic) IBOutlet UIButton *goOnButton;



@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)goBack:(id)sender;
- (IBAction)answerSelected:(id)sender;
- (IBAction)showHint:(id)sender;

@end

@implementation PracticeViewController

-(void)loadView{
    [super loadView];
     self.view.frame = self.view.bounds;
}

-(void)showFeedback:(BOOL)positive{

    _right = positive;
    UIImage * img = positive?[UIImage imageNamed:@"correct"]:[UIImage imageNamed:@"wrong"];
    NSString * feedback = positive?@"Good Job!":@"Try again!";
    self.fedbackLabel.text = feedback;
    self.feedbackImageView.image= img;
    self.feedbackView.alpha = 0;
    
   [self.view addSubview:self.feedbackView];

    [UIView animateWithDuration:0.8 animations:^{
        self.feedbackView.alpha = 1;
        CGRect r = self.feedbackView.frame;
        CGPoint center =self.view.center;

        NSLog(@"%f %f, %f",self.view.bounds.size.width, CGRectGetWidth(r),center.x);
        
        float x = center.x -  CGRectGetHeight(r)/2.0;
        float y = center.y -  CGRectGetWidth(r)/2.0;
        r.origin.x = y;
        r.origin.y = x;
        self.feedbackView.frame = r;
        

    }];
}

-(IBAction)dismissView:(id)sender
{
    UIView *v = [sender superview];
    [UIView animateWithDuration:0.8 animations:^{
        v.alpha  = 0;
        
    }completion:^(BOOL finished) {
        [v  removeFromSuperview];
  
    }];

}

- (IBAction)dismissFeedback:(id)sender {
    if(_right){
        [self nextQuestion];
    }
    [self dismissView:sender];
 

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if(!_introShown){
     
        self.introShown = YES;
        

    }
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _utilities= [[MFUtilities alloc]init];
    _dataManager =[[DataManager alloc] init];
    _currentQuestionIndex =0;
    _wrongCount=0;
    _soundHelper = [[SoundHelper alloc]init];
    
    [self loadData];
   
    
    
    [_utilities presentIntroForActivity:self.activityId inViewController:self];
    
}


- (IBAction)dismiss:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)nextQuestion{
     _currentQuestionIndex++;
 
    if(_currentQuestionIndex<self.questionsSet.count){
        [self displayFraction];
    }
    else{
        //Game Over
        [self.dataManager markActivity:self.activityId asCompletedForUser:self.manager.mfuser];
        [self.view addSubview: self.gameOver];
    }
}

-(void)displayFraction{
   
    id question = self.questionsSet[_currentQuestionIndex];

        if([question isKindOfClass:[NSArray class]]){
            [_currentVC performSelector:@selector(setCurrentFractions:) withObject:question];
        }
        if([question isKindOfClass:[MFFraction class]]){
            
            [_currentVC performSelector:@selector(setCurrentFractions:) withObject:@[question]];
            
        }
}

-(void)loadData{
    
    
    
    //Get activity data. This method is loading dynamically questions sets and etc.
     self.currentActivity = [_dataManager getActivity:self.activityId];
    _currentQuestionIndex =0;
    NSMutableArray * a= self.currentActivity.set.allObjects.mutableCopy;
    
    
    if(self.currentActivity.fractionCount.intValue>1){
        
        NSMutableArray * array = [NSMutableArray new];
        int count = a.count;
        while(a.count>0) {
            int random =arc4random()%a.count;
            MFFraction  *a1 = a[random];
            
            [a removeObjectAtIndex:random];
            count--;
            if(a.count==0)break;
            random =arc4random()%a.count;
            
            MFFraction  *a2 = a[random];
            [a removeObjectAtIndex:random];
            
            NSArray * k =@[a1,a2];
            [array addObject:k];
        }
        self.questionsSet = array;
    }
    else{
        self.questionsSet = a;
        
    }
    

    
    if([self.currentActivity.name isEqualToString:@"Tip The Scale"]){
      
        
        _scaleVC = [[MFScaleActivity alloc]initWithNibName:@"MFScaleActivity" bundle:nil];
        [self addChildViewController:_scaleVC];
        [_scaleVC willMoveToParentViewController:self];

        [self.activityContainer addSubview:_scaleVC.view];
        [_scaleVC didMoveToParentViewController:self];
        _currentVC = self.scaleVC;
    }
    
    if([self.currentActivity.name isEqualToString:@"Candy Bar Activity"]){
        _numberLineVC = [[NumberLineViewController alloc]initWithNibName:@"NumberLineViewController" bundle:nil];
        [self addChildViewController:_numberLineVC];
        [_numberLineVC willMoveToParentViewController:self];
        
        [self.activityContainer addSubview:_numberLineVC.view];
        [_numberLineVC didMoveToParentViewController:self];
        _currentVC = self.numberLineVC;
        
    }
    if([self.currentActivity.name isEqualToString:@"Filling the Glass Activity"]) {
        _glassVC = [[MFGlassActivityViewController alloc]initWithNibName:@"GlassActivityView" bundle:[NSBundle mainBundle]];
        
        [self addChildViewController:_glassVC];
        [_glassVC willMoveToParentViewController:self];
      
        [self.activityContainer addSubview:_glassVC.view];
        [_glassVC didMoveToParentViewController:self];

        _currentVC = _glassVC;
 
    }
    
    [self.view addSubview:  self.homeButton];
    [self.view addSubview:self.hintButton];
    [self.view addSubview:self.goOnButton];
    
    [self displayFraction];
    
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activateAlert:(id)sender {
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Fractio" message:@"Are you sure you want to exit?" cancelButtonTitle:@"No, just kidding." otherButtonTitles:@"Yes",nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
        if (didCancel) {
            NSLog(@"User cancelled");
            return;
        }
        switch (selectedIndex) {
            case 1:
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case 2:
                NSLog(@"2 selected");
                break;
            default:
                break;
        }
    }];
}



- (IBAction)goBack:(id)sender {
    [self activateAlert:sender];
    
}


//method will be called when user submits the answer
- (IBAction)answerSelected:(id)sender {


   
    if(!_manager)
    {
        _manager = [MFManager sharedManager];
    }
    
    id question = self.questionsSet[_currentQuestionIndex];
   
    [(id <MFPracticeRequiredMethods>) self.currentVC checkAnswer:^(BOOL check, MFFraction* answer) {
          [_soundHelper playSound:check];
        if(check)
        {
            [self showFeedback:YES];
            
            
        }
        else{
            _wrongCount ++;
            
            //introduce a new problem after three attempts
            if(_wrongCount > 2)
            {
                //reset the counter
                _wrongCount = 0;

                //show the answer
                [self nextQuestion];

            }
            else{
                [self showFeedback:NO];
            }
        }
        NSSet *set;
        if([question isKindOfClass:[NSArray class]]){
            set = [NSSet setWithArray:question];
        }
        if([question isKindOfClass:[MFFraction class]])
        {
            set = [NSSet setWithObject:question];
        }
        
        [self.dataManager saveAttemptWithScore:check andActivity:self.currentActivity andFractions:set andAnswer:answer];
    }];
}

- (IBAction)showHint:(id)sender {
    
    [_utilities presentIntroForActivity:self.activityId inViewController:self];
}
@end
