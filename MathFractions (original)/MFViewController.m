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
@property (strong, nonatomic) IBOutlet UITextField *pin1;
@property (strong, nonatomic) IBOutlet UITextField *pin2;
@property (strong, nonatomic) IBOutlet UITextField *pin3;

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;


@property (strong, nonatomic) NSArray * array;

- (IBAction)showMenu:(id)sender;
- (IBAction)hideMenu:(id)sender;
- (IBAction)showIntro:(id)sender;

- (IBAction)loginUser:(id)sender;
- (IBAction)newUser:(id)sender;

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
//if not available show menu
    MFUser * user =  [_dataManager getCurrentUser];
    if(!user){
        [self showMenu:nil];
    
    }
    else{
        [[MFManager sharedManager]setMfuser:user];
    }
}


- (IBAction)showActivity:(id)sender {
    int tag  = [sender tag];
    PracticeViewController * pv = [[PracticeViewController alloc]initWithNibName:@"PracticeViewController" bundle:nil];
    pv.activityId = tag;

    [self presentViewController:pv animated:YES completion:^{}];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if(!_introShown){
       
        [_utilities presentIntroIn:self];
        self.introShown = YES;
    }
    
    //update map
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
        UIAlertView * a = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
    }
    
}

- (IBAction)newUser:(id)sender {
    //DATA MANAGER
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



#warning TO DO restore name and email
#warning TO DO handle saving and restoring progress

@end
