//
//  MenuTableViewCell.h
//  WC Fun 2018
//
//  Created by whoami on 4/14/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *alternativeImageName;

@end
