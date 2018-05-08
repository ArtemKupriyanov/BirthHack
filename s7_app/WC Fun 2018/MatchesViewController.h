//
//  ViewController.h
//  WC
//
//  Created by Vlad on 14/04/2018.
//  Copyright © 2018 Codelovin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchesBeginFlagsTableViewCell.h"
#import "MatchesMainTableViewCell.h"
#import "SWRevealViewController.h"
#import "RatingViewController.h"
@interface MatchesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *countriesTableView;
@property (weak, nonatomic) IBOutlet UIButton *chooseCountryButton;
@property (weak, nonatomic) IBOutlet UILabel *selectedCountryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCountryImageView;
@property (weak, nonatomic) IBOutlet UILabel *pleaseChooseCountryLabel;
@property (weak, nonatomic) IBOutlet UITableView *matchesTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end

