//
//  MatchesMainTableViewCell.h
//  WC
//
//  Created by Vlad on 14/04/2018.
//  Copyright © 2018 Codelovin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchesMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftTeamLogo;
@property (weak, nonatomic) IBOutlet UIImageView *rightTeamLogo;
@property (weak, nonatomic) IBOutlet UILabel *leftTeamName;
@property (weak, nonatomic) IBOutlet UILabel *rightTeamName;
@property (weak, nonatomic) IBOutlet UILabel *winProb1;
@property (weak, nonatomic) IBOutlet UILabel *winProb1Label;
@property (weak, nonatomic) IBOutlet UILabel *winDraw;
@property (weak, nonatomic) IBOutlet UILabel *winDrawLabel;
@property (weak, nonatomic) IBOutlet UILabel *winProb2;
@property (weak, nonatomic) IBOutlet UILabel *winProb2Label;
@property (weak, nonatomic) IBOutlet UILabel *matchDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stadiumTitle;
@property (weak, nonatomic) IBOutlet UILabel *stadiumPlace;
@property (weak, nonatomic) IBOutlet UIView *custView1;
@property (weak, nonatomic) IBOutlet UIView *custView2;
@property (weak, nonatomic) IBOutlet UIButton *goToS7;

@property (weak, nonatomic) IBOutlet UISwitch *switchGo;
@property (weak, nonatomic) IBOutlet UIImageView *stadium;
@property (weak, nonatomic) IBOutlet UIButton *companionsButton;

@end
