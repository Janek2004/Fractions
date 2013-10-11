//
//  ProgressCell.h
//  MathFractions
//
//  Created by Janusz Chudzynski on 10/11/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UILabel *fractionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activityImageView;

@end
