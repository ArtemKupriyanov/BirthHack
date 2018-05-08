//
//  RatingViewController.m
//  WC Fun 2018
//
//  Created by whoami on 4/14/18.
//  Copyright © 2018 Mountain Viewer. All rights reserved.
//

#import "RatingViewController.h"
#import "SWRevealViewController.h"
#import "PlayerTableViewCell.h"

#import <SafariServices/SafariServices.h>
#import <NYAlertViewController.h>

@interface RatingViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftCountry;
@property (weak, nonatomic) IBOutlet UIImageView *rightCountry;

@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *leftSurname;

@property (weak, nonatomic) IBOutlet UILabel *rightName;
@property (weak, nonatomic) IBOutlet UILabel *rightSurname;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (strong, nonatomic) NSArray<NSString *> *names;
@property (strong, nonatomic) NSArray<NSString *> *surnames;
@property (strong, nonatomic) NSArray<NSString *> *nationalities;
@property (strong, nonatomic) NSArray<NSString *> *flags;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray<NSNumber *> *sortedRating;

@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic) NSUInteger counter;
@property (strong, nonatomic) NSArray<NSNumber *> *ratings;

@end

@implementation RatingViewController

- (void)configureRevealVC {
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController) {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}
- (IBAction)segmentedControlChangedValue:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.chooseView];
    } else {
        [self.view bringSubviewToFront:self.playerView];
    }
}

- (void)makeBorders {
    
    self.leftCountry.layer.borderWidth = 1.0;
    self.rightCountry.layer.borderWidth = 1.0;
    
    self.leftCountry.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rightCountry.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.leftCountry.layer.cornerRadius = self.leftCountry.bounds.size.height / 2.0;
    self.rightCountry.layer.cornerRadius = self.rightCountry.bounds.size.height / 2.0;
}

- (void)makeNewPair {
    int left = arc4random() % 18;
    int right = arc4random() % 18;
    
    while (left == right) {
        left = arc4random() % 18;
        right = arc4random() % 18;
    }
    
    self.leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_l", left + 1]];
    self.rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_r", right + 1]];
    
    self.leftCountry.image = [UIImage imageNamed:self.flags[left]];
    self.rightCountry.image = [UIImage imageNamed:self.flags[right]];
    
    self.leftName.text = self.names[left];
    self.rightName.text = self.names[right];
    
    self.leftSurname.text = self.surnames[left];
    self.rightSurname.text = self.surnames[right];
}

- (IBAction)leftImageTapped:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.leftView.backgroundColor = [UIColor cyanColor];
    }];
    
    self.counter += 1;
    [self makeNewPair];
    if (self.counter == 20) {
        self.counter = 0;
        [self showAlert];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.leftView.backgroundColor = [UIColor clearColor];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Go"];
}

- (IBAction)rightImageTapped:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Go"];
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.backgroundColor = [UIColor cyanColor];
    }];
    
    self.counter += 1;
    [self makeNewPair];
    if (self.counter == 10) {
        self.counter = 0;
        [self showAlert];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.rightView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)showAlert {
    NYAlertViewController *alertVC = [[NYAlertViewController alloc] init];
    
    alertVC.title = @"S7";
    alertVC.titleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:25.0];
    alertVC.titleColor = [UIColor blackColor];
    
    alertVC.message = @"It's time to choose tickets to World Cup 2018 in Russia!";
    alertVC.messageFont = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
    
    alertVC.cancelButtonColor = [UIColor colorWithRed:190.0 / 255.0 green:212.0 / 255.0 blue:44.0 / 255.0 alpha:1];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"s7"];
    
    alertVC.alertViewContentView = imageView;
    
    NYAlertAction *okAction = [NYAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(NYAlertAction *action) {
                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    
    NYAlertAction *visitAction = [NYAlertAction actionWithTitle:@"Move on S7" style:UIAlertActionStyleCancel handler:^(NYAlertAction *action) {
        NSString *webAddress = @"http://www.s7.ru";
        NSURL *url = [[NSURL alloc] initWithString:webAddress];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^ {
            [alertVC presentViewController:safariVC animated:YES completion:nil];
        });
    }];
    
    [alertVC addAction:okAction];
    [alertVC addAction:visitAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    PlayerTableViewCell *cell = (PlayerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSUInteger sortedIndex = [self.sortedRating[indexPath.row] integerValue];
    
    cell.playerLabel.text = [NSString stringWithFormat:@"%@ %@", self.names[sortedIndex], self.surnames[sortedIndex]];
    
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];
    cell.scoreLabel.text = [NSString stringWithFormat:@"Score: %@%%", self.ratings[indexPath.row]];
    cell.flagImageView.image = [UIImage imageNamed:self.flags[sortedIndex]];
    cell.flagImageView.layer.cornerRadius = cell.flagImageView.bounds.size.height / 2.0;
    cell.flagImageView.layer.borderWidth = 1.0;
    cell.flagImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureRevealVC];
    [self makeBorders];
    [self initPlayerData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.counter = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initPlayerData {
    
    self.names = @[@"Eden", @"Lionel", @"Jerome", @"Paulo", @"Olivier", @"Antoine", @"Gonzalo", @"Andres", @"Harry", @"Luis", @"Luka", @"Manuel", @"Cristiano", @"Mesut", @"Alexis", @"Sergio", @"David", @"Raheem"];
    
    self.surnames = @[@"Hazard", @"Messi", @"Boateng", @"Dybala", @"Giroud", @"Griezmann", @"Higuain", @"Iniesta", @"Kane", @"Suarez", @"Modric", @"Neuer", @"Ronaldo", @"Ozil", @"Sanchez", @"Ramos", @"Silva", @"Sterling"];
    
    self.nationalities = @[@"Belgium", @"Argentina", @"Germany", @"Argentina", @"French", @"French", @"Argentina", @"Spain", @"English", @"Uruguay", @"Croatia", @"Germany", @"Portugal", @"Germany", @"Chile", @"Spain", @"Spain", @"English"];
    
    self.flags = @[@"be", @"ar", @"de", @"ar", @"fr", @"fr", @"ar", @"es", @"gb", @"uy", @"hr", @"de", @"pt", @"de", @"cl", @"es", @"es", @"gb"];
    
    self.sortedRating = @[@12, @1, @5, @0, @11, @9, @8, @7, @14, @3, @10, @13, @15, @4, @2, @17, @6, @16];
    
    self.ratings = @[@98.8, @93.3, @83.2, @74.2, @71.3, @69.2, @63.5, @57.2, @53.8, @47.1, @43.6, @41.9, @38.2, @34.2, @27.1, @24.3, @18.1, @15.7];
}

@end
