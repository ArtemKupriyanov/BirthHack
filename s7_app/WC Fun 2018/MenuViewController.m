//
//  MenuViewController.m
//  WC Fun 2018
//
//  Created by whoami on 4/14/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import <SafariServices/SafariServices.h>

@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MenuViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"Cell";
    
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.cellLabel.text = @"Players";
        cell.cellLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        //        cell.cellLabel.textColor = [UIColor whi];
        cell.imageName = @"rating_white";
        cell.alternativeImageName = @"rating_white";
        cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
    } else if (indexPath.row == 1) {
        cell.cellLabel.text = @"Matches";
        cell.cellLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        //        cell.cellLabel.textColor = [UIColor blackColor];
        cell.imageName = @"match_white";
        cell.alternativeImageName = @"match_white";
        cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
    } else if (indexPath.row == 2) {
        cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
        cell.cellLabel.text = @"Predictions";
        cell.cellLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        //        cell.cellLabel.textColor = [UIColor blackColor];
        cell.imageName = @"group_white";
        cell.alternativeImageName = @"group_white";
        cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
    } else if (indexPath.row == 3) {
        cell.cellLabel.text = @"Tickets";
        cell.cellLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        //        cell.cellLabel.textColor = [UIColor blackColor];
        cell.imageName = @"ticket_white";
        cell.alternativeImageName = @"ticket_white";
        cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
    } else if (indexPath.row == 4) {
        cell.cellLabel.text = @"Feedback";
        cell.cellLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18];
        //        cell.cellLabel.textColor = [UIColor blackColor];
        cell.imageName = @"mail_white";
        cell.alternativeImageName = @"mail_white";
        cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.cellLabel.textColor = [UIColor whiteColor];
    cell.cellImageView.image = [UIImage imageNamed:cell.alternativeImageName];
    cell.contentView.backgroundColor = [UIColor colorWithRed:71.0/255.0 green:154.0/255.0 blue:77.0/255.0 alpha:1.0];
    
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"rating" sender:self];
    } else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"match" sender:self];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"group" sender:self];
    } else if (indexPath.row == 3) {
        [self buyTickets];
    } else if (indexPath.row == 4) {
        [self composeMail];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    cell.cellLabel.textColor = [UIColor whiteColor];
    cell.cellImageView.image = [UIImage imageNamed:cell.imageName];
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (void) buyTickets {
    NSString *webAddress = @"http://www.s7.ru";
    NSURL *url = [[NSURL alloc] initWithString:webAddress];
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:safariVC animated:YES completion:nil];
}

- (void)composeMail {
    NSString *emailTitle = @"Обращение в службу поддержки";
    
    NSArray *toRecipents = [NSArray arrayWithObject:@"mountainviewer@yahoo.com"];
    
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    
    if ([MFMailComposeViewController canSendMail]) {
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:emailTitle];
        [mailComposeVC setToRecipients:toRecipents];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
