//
//  PlayerTableViewCell.h
//  WC Fun 2018
//
//  Created by whoami on 4/15/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
