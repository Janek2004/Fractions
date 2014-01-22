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
#import "MFActivity.h"
#import "MFCompleted.h"
#import "MFProgressViewController.h"
#import "MailHelper.h"

@interface MFViewController ()
@property (strong, nonatomic) IBOutlet UIView *MenuView;
@property (nonatomic) BOOL introShown;
@property (nonatomic,strong)MFUtilities * utilities;
@property (nonatomic,strong)DataManager * dataManager;
@property (nonatomic,strong)MFManager * manager;


@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *fractioImageView;
@property (strong, nonatomic) NSArray * array;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (strong, nonatomic) IBOutlet UIView *userView;
@property (strong, nonatomic) IBOutlet UIView *teacherGuideView;
@property (strong, nonatomic) IBOutlet UIView *registrationView;


@property (strong, nonatomic) IBOutlet UITextField *loginPasswordTxtField;

@property (strong, nonatomic) IBOutlet UITextField *registrationPassword;
@property (strong, nonatomic) IBOutlet UITextField *firstnameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *registrationUserName;


@property (strong, nonatomic) IBOutlet UITextField *classIdTxtField;
@property (strong,nonatomic)MailHelper * mailHelper;

- (IBAction)showMenu:(id)sender;
- (IBAction)hideMenu:(id)sender;
- (IBAction)showIntro:(id)sender;

- (IBAction)loginUser:(id)sender;
- (IBAction)registerUser:(id)sender;


- (IBAction)activityInfo:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)showUserView:(id)sender;
- (IBAction)showTeacherGuide:(id)sender;
- (IBAction)dismissView:(id)sender;
- (IBAction)showProgress:(id)sender;

- (IBAction)contactSupport:(id)sender;

@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _array =@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10];
    _utilities= [[MFUtilities alloc]init];
    _dataManager = [[DataManager alloc]init];


    _mailHelper =[[MailHelper alloc]init];
    
    NSArray * images = @[[UIImage imageNamed:@"walk1"],[UIImage imageNamed:@"walk2"],[UIImage imageNamed:@"walk3"],[UIImage imageNamed:@"walk4"]];
    
    self.fractioImageView.animationImages = images;
    self.fractioImageView.animationDuration=1;
    [self.fractioImageView startAnimating];
    
    [self showUserView:nil];
    
   // MFUser * user =  [_dataManager getCurrentUser];
 //   if(!user){
    
    
//    }
//    else{
//        [[MFManager sharedManager]setMfuser:user];
//        self.userNameTextField.text = user.name;
//        self.userName.text = [NSString stringWithFormat:@"Hi %@", user.name];
//        self.classIdTxtField.text = user.classId;
//    }
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
         CGRect r1 =    self.fractioImageView.frame;
             r1.origin = btn.frame.origin;
             self.fractioImageView.frame =r1;
 
        PracticeViewController * pv = [[PracticeViewController alloc]initWithNibName:@"PracticeViewController" bundle:nil];
         pv.activityId = btn.tag;
        [self presentViewController:pv animated:YES completion:^{
            
        }];
         
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
    for(int i=1;i<=6;i++){
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        NSString * imageName = [_utilities getImageForActivity:i  correct:NO];
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    
    MFUser * mf = [[MFManager sharedManager]mfuser];
   
    
    for(MFCompleted *act in mf.completed){
        
        
        [UIView animateWithDuration:1.0 animations:^{
            NSString * imageName = [_utilities getImageForActivity:act.activity.integerValue  correct:YES];
            
            [(UIButton*)[self.view viewWithTag:act.activity.integerValue]setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            
        }];
    }
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
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Tap on the User button to log in or create a new user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];
        return;
    }
    
    if(self.classIdTxtField.text.length>0){
        [[MFManager sharedManager]setClassId:self.classIdTxtField.text];
        MFUser * mf = [[MFManager sharedManager]mfuser];
        mf.classId =self.classIdTxtField.text;
        [_dataManager updateData:mf];
        
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
    if(self.userNameTextField.text.length==0||self.loginPasswordTxtField.text.length==0)
    {
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];
        return;
    }
    
    else{
        
        [self.dataManager loginUser:self.userNameTextField.text andPassword:self.loginPasswordTxtField.text block:^{
            [self dismissView:sender];
            
        }];
    
    }
    
    
//    //TO DO
//    NSNumber * pin1 = _array[[_pickerView selectedRowInComponent:0]];
//    NSNumber * pin2 = _array[[_pickerView selectedRowInComponent:1]];
//    NSNumber * pin3 = _array[[_pickerView selectedRowInComponent:2]];
//    NSNumber * pin4 = _array[[_pickerView selectedRowInComponent:3]];
//    
//    NSString * pin = [NSString stringWithFormat:@"%@%@%@%@",pin1,pin2,pin3,pin4];
//    NSString * name = _userNameTextField.text;
//    
//    MFUser * mf =  [self.dataManager findUserWithPin:pin andName:name];
//    
//    
//    if(!mf){
//
//        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"User with this pin and name doesn't exist." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [a show];
//        
//    }
//    else{
//        [self.dataManager loginUser:mf];
//        [self dismissView:sender];
//        [self hideMenu:nil];
//        self.userName.text = [NSString stringWithFormat:@"Hi %@", mf.name];
//    }
}


- (IBAction)registerUser:(id)sender {
    NSString * username = _registrationUserName.text;
    // NSString *
    NSString * firstname= _firstnameTxtField.text;
    NSString * lastname = _lastNameTxtField.text;
    NSString * password = _registrationPassword.text;
    NSString *classId = _classIdTxtField.text;
    
    if(firstname.length >0 && lastname.length>0 && password.length >0 && classId.length >0&&username.length>0){
        id weakself = self;
        [self.dataManager addNewUserWithPin:password andName:username classId:classId first:firstname last:lastname successBlock:^{
            [weakself showUserView:nil];
            [weakself dismissView:[weakself registrationView]];
    }];
    
    }
    else{
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Fill all the fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [a show];
    }
    
    
    
}
/*
- (IBAction)newUser:(id)sender {
    //DATA MANAGER
   
    NSString * username = _registrationUserName.text;
   // NSString *
    NSString * firstname= _firstnameTxtField.text;
    NSString * lastname = _lastNameTxtField.text;
    NSString * password = _registrationPassword.text;
    NSString *classId = _classIdTxtField.text;
    [self.dataManager addNewUserWithPin:password andName:username classId:classId first:firstname last:lastname];
    
    
//    
//    if(newuser){
//        [self.dataManager loginUser:newuser];
//        [[MFManager sharedManager]setMfuser: newuser];
//         self.userName.text = [NSString stringWithFormat:@"Hi %@", newuser.name];
//        
//        [self dismissView:sender];
//        [self hideMenu:nil];
//
//    }
}
*/

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

- (IBAction)showRegistrationView:(id)sender {
    [self.view addSubview:self.registrationView];
    self.registrationView.alpha = 0;
    [UIView animateWithDuration:1
                     animations:^{
                         self.registrationView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         self.registrationView.bounds = self.view.bounds;
                         
                     }];
    
}


- (IBAction)continueAsGuest:(id)sender {
    //remove current user
    
    
    //dismiss
    [self dismissView:sender];
    
}






- (IBAction)showTeacherGuide:(id)sender {
    [self.view addSubview:self.teacherGuideView];
    self.teacherGuideView.alpha = 0;
    [UIView animateWithDuration:1
                     animations:^{
                         self.teacherGuideView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         self.teacherGuideView.bounds = self.view.bounds;
                         
                     }];
}

- (IBAction)dismissView:(id)sender {
    [UIView animateWithDuration:1
                     animations:^{
                         [[sender superview]setAlpha:0];
                         
                     } completion:^(BOOL finished) {
                         //[[[sender superview]superview] removeFromSuperview];

                        [[sender superview] removeFromSuperview];
                         
                     }];


}

- (IBAction)showProgress:(id)sender {
    
    MFProgressViewController *mf = [[MFProgressViewController alloc]initWithNibName:@"MFProgressViewController" bundle:nil];
    [self presentViewController:mf animated:YES completion:nil];
    
    
    
}

- (IBAction)contactSupport:(id)sender {
    [_mailHelper sendEmailFromVC:self];
    
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


    - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row



            forComponent:(NSInteger)component;{
       return  [NSString stringWithFormat:@"%@",_array[row]];

}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text =[NSString stringWithFormat:@"%@",_array[row]];
    lbl.textColor = [UIColor whiteColor];
    
    return lbl;
    
}



- (IBAction)usernameTxtField:(id)sender {
}
@end
