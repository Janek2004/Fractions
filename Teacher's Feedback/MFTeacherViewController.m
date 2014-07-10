//
//  MFTeacherViewController.m
//  Fractio
//
//  Created by sadmin on 1/30/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import "MFTeacherViewController.h"
#import "DataSource.h"
#import  "DataManager.h"
#import  "MFManager.h"
#import "MFTeacherCell.h"


@interface MFTeacherViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property ( strong, nonatomic) DataSource * dataSource;
@property ( strong, nonatomic) DataManager * dataManager;
@property ( strong, nonatomic) MFManager * manager;

@end

@implementation MFTeacherViewController
- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // get items from the manager
    [self.tableView registerNib:[UINib nibWithNibName:@"TeacherFeedbackCell" bundle:nil] forCellReuseIdentifier:@"teachercell"];
   
    _manager = [MFManager sharedManager];
    _dataManager = [[DataManager alloc]init];
    
    [_dataManager teacherFeedbackForUser:_manager.mfuser.userid completionBlock:^(NSArray *a) {
        _dataSource = [[DataSource alloc]initWithItems:a cellIdentifier:@"teachercell" configureCellBlock:^(MFTeacherCell * cell, id message, id indexPath) {
            NSLog(@"Message %@", message);
            int dateint =(int) [[message objectForKey:@"messagedate"]integerValue];
            NSString * name =[message objectForKey:@"teachername"];
          //  NSString * lastname =[message objectForKey:@"teacherlastname"];
            NSString * messagetext =[message objectForKey:@"messagetext"];
            
            NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:dateint];
 
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.timeStyle = NSDateFormatterMediumStyle;
            df.dateStyle= NSDateFormatterShortStyle;
            
            NSString * dateString = [df stringFromDate:date];
            
            cell.teacher.text = name;
            cell.comment.text = messagetext;
            cell.date.text = dateString;
            
            
        }];
        self.tableView.dataSource = self.dataSource;
        [self.tableView reloadData];

    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
