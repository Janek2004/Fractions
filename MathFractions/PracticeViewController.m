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
#import "PracticeViewController.h"
#import "NumberLineView.h"
#import "ATCScaleView.h"
#import "UIBAlertView.h"
#import "DataManager.h"
#import "MFManager.h"

#import "MFFraction.h"
#import  "MFActivityModel.h"
#import "MFPracticeRequiredMethods.h"
#import "MFAttempt.h"

@interface PracticeViewController ()
@property (nonatomic) BOOL  introShown;
@property (nonatomic,strong) MFUtilities * utilities;
@property (nonatomic,strong) DataManager * dataManager;
@property (nonatomic,strong) MFManager * manager;
@property (nonatomic,strong) MFActivityModel *currentActivity;

@property (nonatomic,strong) UIView * practiceView;
@property (strong, nonatomic) IBOutlet UIView *activityContainer;
@property int currentQuestionIndex;
@property int wrongCount;

@property (strong, nonatomic) IBOutlet UIView *gameOver;


- (IBAction)goBack:(id)sender;
- (IBAction)answerSelected:(id)sender;
- (IBAction)showHint:(id)sender;

@end

@implementation PracticeViewController

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
    
    [self loadData];
   
    [_utilities presentIntroForActivity:self.activityId inViewController:self];
    
}


- (IBAction)dismiss:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)nextQuestion{
    _currentQuestionIndex++;
    if(_currentQuestionIndex<self.currentActivity.questionsSet.count){
        [self displayFraction];
    }
    else{
        //Game Over
         NSLog(@"GAME OVER Screen");
        [self.view addSubview: self.gameOver];
        
        
    }
}

-(void)displayFraction{
    if([self.practiceView respondsToSelector:@selector(setCurrentFractions:)]){

        [(id <MFPracticeRequiredMethods>) self.practiceView  reset];
        id question =self.currentActivity.questionsSet[_currentQuestionIndex];
      
        if([question isKindOfClass:[NSArray class]]){
            [self.practiceView performSelector:@selector(setCurrentFractions:) withObject:question];
        }
        if([question isKindOfClass:[MFFraction class]]){
            
            [self.practiceView performSelector:@selector(setCurrentFractions:) withObject:@[question]];
        
        }
        
    }
}

-(void)loadData{
    //Get activity data. This method is loading dynamically questions sets and etc.
    self.currentActivity = [_dataManager getActivity:self.activityId];
   
    id <MFPracticeRequiredMethods> activityView    = [[NSClassFromString(self.currentActivity.className) alloc]initWithFrame:self.activityContainer.bounds];
    self.practiceView = (UIView *) activityView;
    [self.activityContainer addSubview:self.practiceView];
    _currentQuestionIndex =0;
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
   
    //calculate score
    if([self.practiceView respondsToSelector:@selector(checkAnswer)]){
        BOOL check =  (BOOL)[(id <MFPracticeRequiredMethods>) self.practiceView performSelector:@selector(checkAnswer)];
        if(check){
            //good job - > new question
            //play sound
            NSLog(@"Good Job");
            
            
            MFAttempt *attempt = [[MFAttempt alloc]init];
            attempt.attempt_date = [NSDate new];
            attempt.score =[[NSNumber numberWithBool:check]integerValue];
            attempt.fractions =[(id <MFPracticeRequiredMethods>)  self.practiceView currentFractions];
            attempt.activity = self.activityId;
            
            _manager = [MFManager sharedManager];
           [self.dataManager saveAttempt:attempt forUser:self.manager.mfuser];
           [self nextQuestion];
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Good Job!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
            
        }
        else{
            _wrongCount ++;
            NSLog(@"Bad");
            UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [a show];
            
        }
    }
    
    //compare the scores
    //current answer
    
    
}

- (IBAction)showHint:(id)sender {
}
@end
