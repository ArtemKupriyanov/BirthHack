//
//  GroupViewController.m
//  WC Fun 2018
//
//  Created by whoami on 4/14/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

#import "GroupViewController.h"
#import "SWRevealViewController.h"
#import <SafariServices/SafariServices.h>

@interface GroupViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *groupTableView;
@property (weak, nonatomic) IBOutlet UIButton *predictionsButton;

@end

@implementation GroupViewController

- (IBAction)predictionsButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"tree" sender:self];
}
- (IBAction)ticketsButtonTapped:(id)sender {
    NSString *webAddress = @"http://www.s7.ru";
    NSURL *url = [[NSURL alloc] initWithString:webAddress];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:safariVC animated:YES completion:nil];
}

- (void)configurePredictionsButton {
    self.predictionsButton.layer.borderWidth = 1.0;
    self.predictionsButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.predictionsButton.layer.cornerRadius = 5.0;
}

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
    [self configurePredictionsButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
