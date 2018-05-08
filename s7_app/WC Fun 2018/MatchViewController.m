//
//  MatchViewController.m
//  WC Fun 2018
//
//  Created by whoami on 4/14/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

#import "MatchViewController.h"
#import "SWRevealViewController.h"

@interface MatchViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation MatchViewController

- (void)configureRevealVC {
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController) {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRevealVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
