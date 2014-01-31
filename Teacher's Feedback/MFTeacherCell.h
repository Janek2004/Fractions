//
//  MFTeacherCell.h
//  Fractio
//
//  Created by sadmin on 1/30/14.
//  Copyright (c) 2014 UWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFTeacherCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (strong, nonatomic) IBOutlet UILabel *teacher;

@end
