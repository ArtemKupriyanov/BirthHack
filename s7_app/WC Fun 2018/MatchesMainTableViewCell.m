//
//  MatchesMainTableViewCell.m
//  WC
//
//  Created by Vlad on 14/04/2018.
//  Copyright © 2018 Codelovin. All rights reserved.
//

#import "MatchesMainTableViewCell.h"

@implementation MatchesMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4;
    _custView2.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
