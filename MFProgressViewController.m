//
//  MFProgressViewController.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/11/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MFProgressViewController.h"
#import "ArrayDataSource.h"
#import "DataManager.h"

#import "MFLocalStudent.h"
#import "ProgressCell.h"
#import "MFAttempt.h"
#import "MFFraction.h"

#import "MFUtilities.h"

@interface MFProgressViewController ()<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) ArrayDataSource * datasource;
@property (strong,nonatomic) DataManager * dataManager;
@property (strong,nonatomic) MFUtilities * utilities;

@end

@implementation MFProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _utilities = [[MFUtilities alloc]init];
    self.tableView.delegate =self;
    _dataManager = [[DataManager alloc]init];
    MFLocalStudent * user = _dataManager.getCurrentUser;
    NSArray * a= user.attempts.allObjects;
    NSSortDescriptor * sort = [[NSSortDescriptor alloc]initWithKey:@"attempt_date" ascending:NO];
    a =  [a sortedArrayUsingDescriptors:@[sort]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProgressCell"  bundle:nil]forCellReuseIdentifier:@"progressCell"];

    _datasource= [[ArrayDataSource alloc]initWithItems:a cellIdentifier:@"progressCell" configureCellBlock:^(ProgressCell * cell, MFAttempt * item){
        cell.activityName.text =[NSString stringWithFormat:@"Activity: %d", item.activity.intValue];
//        NSDateFormatter * df = [[NSDateFormatter alloc]init];
//       [df setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
//        NSDate * date = [df dateFromString:item.attempt_date];

        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour|NSCalendarUnitMinute fromDate:item.attempt_date];
        
        
        
        NSLog(@"Date %@",item.attempt_date);
        
NSString * str = [NSString stringWithFormat:@"%d/%d/%d %d:%d ", (int)components.month,(int)components.day, (int)components.year,(int)components.hour, (int)components.minute];
        
        
        cell.dateTimeLabel.text = [NSString stringWithFormat:@"%@",str ];
        
        NSMutableString *s = [NSMutableString new];
        
        for(MFFraction * fr in item.fractions)
        {
            [s appendString:[NSString stringWithFormat:@"%@/%@ ",fr.numerator, fr.denominator]];
        }
        cell.fractionsLabel.text =s;

        int i = item.activity.intValue ;
        

        NSString * imageName =[_utilities getImageForActivity:i correct:item.score.intValue];

        
        cell.activityImageView.image =[UIImage imageNamed:imageName];
        
    }];
    self.tableView.dataSource= _datasource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95;
}

@end
