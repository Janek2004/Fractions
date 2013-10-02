//
//  iTenViewController.m
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

#import "MFViewController.h"
#import "MFUtilities.h"
#import "MFManager.h"
#import "DataManager.h"
#import "PracticeViewController.h"


@interface MFViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *MenuView;
@property (nonatomic) BOOL introShown;
@property (nonatomic,strong)MFUtilities * utilities;
@property (nonatomic,strong)DataManager * dataManager;
@property (nonatomic,strong)MFManager * manager;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *fractioImageView;
@property (strong, nonatomic) NSArray * array;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (strong, nonatomic) IBOutlet UIView *userView;


- (IBAction)showMenu:(id)sender;
- (IBAction)hideMenu:(id)sender;
- (IBAction)showIntro:(id)sender;

- (IBAction)loginUser:(id)sender;
- (IBAction)newUser:(id)sender;

- (IBAction)activityInfo:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)showUserView:(id)sender;

- (IBAction)dismissView:(id)sender;

@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _array =@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    _utilities= [[MFUtilities alloc]init];
   _dataManager = [[DataManager alloc]init];
    _pickerView.delegate = self;
    _pickerView.dataSource= self;

    NSArray * images = @[[UIImage imageNamed:@"walk1"],[UIImage imageNamed:@"walk2"],[UIImage imageNamed:@"walk3"],[UIImage imageNamed:@"walk4"]];
    
    self.fractioImageView.animationImages = images;
    self.fractioImageView.animationDuration=1;
    [self.fractioImageView startAnimating];
    
    MFUser * user =  [_dataManager getCurrentUser];
    if(!user){
        [self showMenu:nil];
    
    }
    else{
        [[MFManager sharedManager]setMfuser:user];
        self.userNameTextField.text = user.name;
        self.userName.text = [NSString stringWithFormat:@"Hi %@", user.name];
    }
    
    
}


- (IBAction)showActivity:(id)sender {
    UIButton * btn =  (UIButton *) sender;
    CGRect r =    self.fractioImageView.frame;
    r.origin = btn.frame.origin;
    self.fractioImageView.frame = r;

    
    [UIView animateWithDuration:1 animations:^{
        self.fractioImageView.center = btn.center;
        
    } completion:
     
     ^(BOOL finished) {
         if(finished){
         self.fractioImageView.center = btn.center;
         CGRect r =    self.fractioImageView.frame;
         r.origin = btn.frame.origin;
         self.fractioImageView.frame = r;
 
        PracticeViewController * pv = [[PracticeViewController alloc]initWithNibName:@"PracticeViewController" bundle:nil];
         pv.activityId = btn.tag;
        [self presentViewController:pv animated:YES completion:^{}];
         
         }
         
     }];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    if(!_introShown){
       
        [_utilities presentIntroIn:self];
        self.introShown = YES;
    }
    
    //update map
    [self checkProgress];
}

-(void)checkProgress{
    //get current progress
    MFUser * mf = [[MFManager sharedManager]mfuser];
    //set unselected images as well
    
//    for(NSNumber * nm in mf.completed){
//        [UIView animateWithDuration:1.0 animations:^{
//                        [(UIButton*)[self.view viewWithTag:nm.integerValue]setBackgroundImage:nil forState:UIControlStateNormal];
//           // [(UIButton*)[self.view viewWithTag:nm.integerValue]setBackgroundColor:[UIColor redColor]]; //] forState:UIControlStateNormal];
//            [(UIButton*)[self.view viewWithTag:nm.integerValue]setBackgroundImage:[UIImage imageNamed:@"selectedDot"] forState:UIControlStateNormal];
//        }];
//    }
}


- (IBAction)showMenu:(id)sender {
    [self.view addSubview:self.MenuView];
    self.MenuView.alpha = 0;
    [UIView animateWithDuration:1
                     animations:^{
                         self.MenuView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         self.MenuView.bounds = self.view.bounds;
                         
                     }];
}

- (IBAction)hideMenu:(id)sender {
    if(self.userNameTextField.text.length==0)
    {
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Tap on User button to log in." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];
        return;
    }
   
    [UIView animateWithDuration:1
                     animations:^{
                         self.MenuView.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         [self.MenuView removeFromSuperview];
                         
                         
                         
                     }];
   
}

- (IBAction)showIntro:(id)sender {
     [_utilities presentIntroIn:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark authentication

- (IBAction)loginUser:(id)sender {
    if(self.userNameTextField.text.length==0)
    {
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];
    }
    //TO DO
    NSNumber * pin1 = _array[[_pickerView selectedRowInComponent:0]];
    NSNumber * pin2 = _array[[_pickerView selectedRowInComponent:1]];
    NSNumber * pin3 = _array[[_pickerView selectedRowInComponent:2]];
    NSNumber * pin4 = _array[[_pickerView selectedRowInComponent:3]];
    
    NSString * pin = [NSString stringWithFormat:@"%@%@%@%@",pin1,pin2,pin3,pin4];
    NSString * name = _userNameTextField.text;
    
    MFUser * mf =  [self.dataManager findUserWithPin:pin andName:name];
    
    
    if(!mf){

        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"User with this pin and name doesn't exist." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];
        
    }
    else{
        [self.dataManager loginUser:mf];
        [self dismissView:sender];
        [self hideMenu:nil];
        self.userName.text = [NSString stringWithFormat:@"Hi %@", mf.name];
    }
}

- (IBAction)newUser:(id)sender {
    //DATA MANAGER
    NSNumber * pin1 = _array[[_pickerView selectedRowInComponent:0]];
    NSNumber * pin2 = _array[[_pickerView selectedRowInComponent:1]];
    NSNumber * pin3 = _array[[_pickerView selectedRowInComponent:2]];
    NSNumber * pin4 = _array[[_pickerView selectedRowInComponent:3]];
    
    NSString * pin = [NSString stringWithFormat:@"%@%@%@%@",pin1,pin2,pin3,pin4];
    NSString * name = _userNameTextField.text;
    
    MFUser * newuser = [self.dataManager addNewUserWithPin:pin andName:name];
    
    
    if(newuser){
        [self.dataManager loginUser:newuser];
        self.userName.text = [NSString stringWithFormat:@"Hi %@", newuser.name];
        
        [self dismissView:sender];
        [self hideMenu:nil];

    }
}

- (IBAction)activityInfo:(id)sender {
    NSLog(@"Activity ");
}

- (IBAction)showAbout:(id)sender {
    
    [self.view addSubview:self.aboutView];
    self.aboutView.alpha = 0;
    [UIView animateWithDuration:1
                     animations:^{
                         self.aboutView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         self.aboutView.bounds = self.view.bounds;
                         
                     }];

    
}

- (IBAction)showUserView:(id)sender {
    [self.view addSubview:self.userView];
   self.userView.alpha = 0;
    [UIView animateWithDuration:1
                     animations:^{
                         self.userView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                        self.userView.bounds = self.view.bounds;
                         
                     }];

    
}

- (IBAction)dismissView:(id)sender {
    [UIView animateWithDuration:1
                     animations:^{
                         [[sender superview]setAlpha:0];
                         
                     } completion:^(BOOL finished) {
                         [[sender superview] removeFromSuperview];
                         
                     }];


}

#pragma mark picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 4;
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return _array.count;

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;{
       return  [NSString stringWithFormat:@"%@",_array[row]];

}





@end
