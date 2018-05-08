//
//  ViewController.m
//  WC
//
//  Created by Vlad on 14/04/2018.
//  Copyright © 2018 Codelovin. All rights reserved.
//

#import "MatchesViewController.h"
#import <NYAlertViewController.h>
@interface MatchesViewController ()
@property (nonatomic, strong) NSArray* countries;
@property (nonatomic, strong) NSArray* countryCodes;
@property (nonatomic, strong) NSMutableArray* matches;
@property (nonatomic, strong) NSArray* allmatches;
@property (nonatomic) int selected;
@property (nonatomic, strong) NSMutableArray* switches;
@property (nonatomic) BOOL shown;
@end

@implementation MatchesViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _shown = FALSE;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"IsNotFirst"] intValue]) {
        _switches = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SwitchesStates"] mutableCopy];
        _selected = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedCountry"]intValue];
         [self countrySelected:NULL];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_selected] forKey:@"SelectedCountry"];
    [[NSUserDefaults standardUserDefaults] setObject:_switches forKey:@"SwitchesStates"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"IsNotFirst"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _switches = [[NSMutableArray alloc] init];
    self.selected = 0;

    [self configureRevealVC];
    _allmatches = @[@[@"Russia",@"Saudi Arabia",@"24",@"61",@"15",@"June, 14",@"Moscow",@"Luzhniki"],@[@"Egypt",@"Uruguay",@"18",@"40",@"42",@"June, 15",@"Ekaterinburg",@"Ekaterinburg"],@[@"Portugal",@"Spain",@"42",@"36",@"22",@"June, 15",@"Sochi",@"Sochi"],@[@"Morocco",@"Iran",@"10",@"58",@"32",@"June, 15",@"St. Petersburg",@"St. Petersburg"],@[@"France",@"Australia",@"59",@"24",@"17",@"June, 16",@"Kazan",@"Kazan"],@[@"Peru",@"Denmark",@"54",@"18",@"28",@"June, 16",@"Saransk",@"Saransk"],@[@"Argentina",@"Iceland",@"60",@"11",@"29",@"June, 16",@"Moscow",@"Spartak"],@[@"Croatia",@"Nigeria",@"54",@"43",@"3",@"June, 16",@"Kaliningrad",@"Kaliningrad"],@[@"Brazil",@"Switzerland",@"54",@"30",@"16",@"June, 17",@"Rostov-na-Donu",@"Rostov-na-Donu"],@[@"Costa Rica",@"Serbia",@"12",@"56",@"32",@"June, 17",@"Samara",@"Samara"],@[@"Germany",@"Mexico",@"64",@"15",@"21",@"June, 17",@"Moscow",@"Luzhniki"],@[@"Sweden",@"South Korea",@"54",@"30",@"16",@"June, 18",@"Nizhny Novgorod",@"Nizhny Novgorod"],@[@"Belgium",@"Panama",@"53",@"22",@"25",@"June, 18",@"Sochi",@"Sochi"],@[@"Tunisia",@"England",@"22",@"9",@"69",@"June, 18",@"Volgograd",@"Volgograd"],@[@"Poland",@"Senegal",@"62",@"32",@"6",@"June, 19",@"Moscow",@"Spartak"],@[@"Colombia",@"Japan",@"63",@"17",@"20",@"June, 19",@"Saransk",@"Saransk"],@[@"Russia",@"Egypt",@"29",@"67",@"4",@"June, 19",@"St. Petersburg",@"St. Petersburg"],@[@"Uruguay",@"Saudi Arabia",@"40",@"35",@"25",@"June, 20",@"Rostov-na-Donu",@"Rostov-na-Donu"],@[@"Portugal",@"Morocco",@"59",@"35",@"6",@"June, 20",@"Moscow",@"Luzhniki"],@[@"Iran",@"Spain",@"27",@"26",@"47",@"June, 20",@"Kazan",@"Kazan"],@[@"France",@"Peru",@"63",@"27",@"10",@"June, 21",@"Ekaterinburg",@"Ekaterinburg"],@[@"Denmark",@"Australia",@"40",@"50",@"10",@"June, 21",@"Samara",@"Samara"],@[@"Argentina",@"Croatia",@"43",@"47",@"10",@"June, 21",@"Nizhny Novgorod",@"Nizhny Novgorod"],@[@"Nigeria",@"Iceland",@"30",@"9",@"61",@"June, 22",@"Volgograd",@"Volgograd"],@[@"Brazil",@"Costa Rica",@"41",@"59",@"0",@"June, 22",@"St. Petersburg",@"St. Petersburg"],@[@"Serbia",@"Switzerland",@"14",@"46",@"40",@"June, 22",@"Kaliningrad",@"Kaliningrad"],@[@"Germany",@"Sweden",@"54",@"30",@"16",@"June, 23",@"Sochi",@"Sochi"],@[@"South Korea",@"Mexico",@"19",@"17",@"64",@"June, 23",@"Rostov-na-Donu",@"Rostov-na-Donu"],@[@"Belgium",@"Tunisia",@"63",@"37",@"0",@"June, 23",@"Moscow",@"Spartak"],@[@"England",@"Panama",@"46",@"25",@"29",@"June, 24",@"Nizhny Novgorod",@"Nizhny Novgorod"],@[@"Poland",@"Colombia",@"56",@"41",@"3",@"June, 24",@"Kazan",@"Kazan"],@[@"Japan",@"Senegal",@"26",@"11",@"63",@"June, 24",@"Ekaterinburg",@"Ekaterinburg"],@[@"Uruguay",@"Russia",@"54",@"18",@"28",@"June, 25",@"Samara",@"Samara"],@[@"Saudi Arabia",@"Egypt",@"26",@"63",@"11",@"June, 25",@"Volgograd",@"Volgograd"],@[@"Iran",@"Portugal",@"4",@"54",@"42",@"June, 25",@"Saransk",@"Saransk"],@[@"Spain",@"Morocco",@"65",@"26",@"9",@"June, 25",@"Kaliningrad",@"Kaliningrad"],@[@"Denmark",@"France",@"9",@"43",@"48",@"June, 26",@"Moscow",@"Luzhniki"],@[@"Australia",@"Peru",@"4",@"40",@"56",@"June, 26",@"Sochi",@"Sochi"],@[@"Nigeria",@"Argentina",@"8",@"52",@"40",@"June, 26",@"St. Petersburg",@"St. Petersburg"],@[@"Iceland",@"Croatia",@"5",@"32",@"63",@"June, 26",@"Rostov-na-Donu",@"Rostov-na-Donu"],@[@"Serbia",@"Brazil",@"15",@"38",@"47",@"June, 27",@"Moscow",@"Spartak"],@[@"Switzerland",@"Costa Rica",@"55",@"31",@"14",@"June, 27",@"Nizhny Novgorod",@"Nizhny Novgorod"],@[@"South Korea",@"Germany",@"1",@"44",@"55",@"June, 27",@"Kazan",@"Kazan"],@[@"Mexico",@"Sweden",@"49",@"45",@"6",@"June, 27",@"Ekaterinburg",@"Ekaterinburg"],@[@"England",@"Belgium",@"11",@"44",@"45",@"June, 28",@"Kaliningrad",@"Kaliningrad"],@[@"Panama",@"Tunisia",@"22",@"28",@"50",@"June, 28",@"Saransk",@"Saransk"],@[@"Japan",@"Poland",@"8",@"28",@"64",@"June, 28",@"Volgograd",@"Volgograd"],@[@"Senegal",@"Colombia",@"3",@"37",@"60",@"June, 28",@"Samara",@"Samara"]];
    _countries = @[@"Poland",@"Australia",@"Japan",@"Spain",@"Belgium",@"Morocco",@"Colombia",@"Denmark",@"Sweden",@"Germany",@"South Korea",@"Peru",@"Argentina",@"Portugal",@"Tunisia",@"Croatia",@"Costa Rica",@"France",@"Serbia",@"Panama",@"Mexico",@"Egypt",@"Russia",@"Brazil",@"Uruguay",@"England",@"Senegal",@"Nigeria",@"Saudi Arabia",@"Iran",@"Iceland",@"Switzerland"];
    _countryCodes = @[@"pl",@"au",@"jp",@"es",@"be",@"ma",@"co",@"dk",@"se",@"de",@"kr",@"pe",@"ar",@"pt",@"tn",@"hr",@"cr",@"fr",@"rs",@"pa",@"mx",@"eg",@"ru",@"br",@"uy",@"gb",@"sn",@"ng",@"sa",@"ir",@"is",@"ch"];
    // Do any additional setup after loading the view, typically from a nib.
    
    _chooseCountryButton.layer.cornerRadius = 6;
    _countriesTableView.layer.cornerRadius = 6;
    
    _countriesTableView.backgroundColor = [UIColor whiteColor];
    _countriesTableView.delegate = self;
    _countriesTableView.dataSource = self;
    
    _pleaseChooseCountryLabel.text = @"Please choose your country:";
    _selectedCountryLabel.text = _countries[0];
    _selectedCountryImageView.image = [UIImage imageNamed:_countryCodes[0]];
    _selectedCountryImageView.layer.cornerRadius = _selectedCountryImageView.layer.frame.size.height
    / 2.0;
    _selectedCountryImageView.layer.masksToBounds = YES;
    
    [_chooseCountryButton addTarget:self action:@selector(countrySelected:) forControlEvents:UIControlEventTouchUpInside];
    _matchesTableView.allowsSelection = FALSE;
    _matchesTableView.delegate = self;
    _matchesTableView.dataSource = self;
    _matchesTableView.backgroundColor = [UIColor clearColor];
    _matchesTableView.layer.shadowColor = [UIColor colorWithWhite:0.9 alpha:0.1].CGColor;
    _matchesTableView.layer.shadowOpacity = 0.5;
    
    CGRect frame = _matchesTableView.frame;
    frame.origin.y = self.view.frame.size.height;
    _matchesTableView.frame = frame;
    [self.view setNeedsDisplay];

    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    _backButton.hidden = YES;
    _backButton.layer.cornerRadius = _backButton.frame.size.height/2.0;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return FALSE;
    
}
- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (void) viewWillAppear:(BOOL)animated {
    _matchesTableView.hidden = YES;
}

- (void) updateMatches {
    _matches = [NSMutableArray new];
    for (NSArray* arr in _allmatches) {
        if (arr[0] == _countries[_selected] || arr[1] == _countries[_selected]) {
            [_matches addObject:arr];
        }
    }
    if (!_switches.count) {
        _switches = [[NSMutableArray alloc] init];
        for (int i = 0; i < _matches.count; i++) {
            [_switches addObject:[NSNumber numberWithBool:FALSE]];
        }
    }
}
- (void)showAlert {
    NYAlertViewController *alertVC = [[NYAlertViewController alloc] init];
    
    alertVC.title = @"Companions!";
    alertVC.titleFont = [UIFont fontWithName:@"AvenirNext-Regular" size:25.0];
    alertVC.titleColor = [UIColor blackColor];
    
    alertVC.message = @"We can personalize your experience to select better companions! Try our \"Players\" menu tab!";
    alertVC.messageFont = [UIFont fontWithName:@"AvenirNext-Regular" size:17.0];
    
    alertVC.cancelButtonColor = [UIColor colorWithRed:190.0 / 255.0 green:212.0 / 255.0 blue:44.0 / 255.0 alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"socpl"];
    
    alertVC.alertViewContentView = imageView;
    
    NYAlertAction *okAction = [NYAlertAction actionWithTitle:@"Go!"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(NYAlertAction *action) {
                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                                     }];
  
    [alertVC addAction:okAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)configureRevealVC {
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if (revealViewController) {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void) countrySelected:(id)sender {
    [self updateMatches];
    [_matchesTableView reloadData];
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^(void) {
                         self.pleaseChooseCountryLabel.alpha = 0.0;
                         self.selectedCountryImageView.alpha = 0;
                         self.selectedCountryLabel.alpha = 0;
                         self.chooseCountryButton.alpha = 0;
                         self.countriesTableView.alpha = 0;
                         self.matchesTableView.hidden = NO;
                         self.backButton.alpha = 1.0;
                         self.backButton.hidden = NO;
                     }
                     completion:NULL];
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         CGRect fr = self.matchesTableView.frame;
                         fr.origin.y = 100;
                         self.matchesTableView.frame = fr;
                     }
                     completion:NULL];
}

- (void) back: (id) sender {
    [UIView animateWithDuration:0.55
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^(void) {
                         self.pleaseChooseCountryLabel.alpha = 1.0;
                         self.selectedCountryImageView.alpha = 1.0;
                         self.selectedCountryLabel.alpha = 1.0;
                         self.chooseCountryButton.alpha = 1.0;
                         self.countriesTableView.alpha = 1.0;
                         self.backButton.hidden = NO;
                         self.matchesTableView.hidden = NO;
                         self.backButton.alpha = 0.0;
                     }
                     completion:NULL];
    [UIView animateWithDuration:0.45
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         CGRect fr = self.matchesTableView.frame;
                         fr.origin.y = self.view.frame.size.height;
                         self.matchesTableView.frame = fr;
                     }
                     completion:^(BOOL finished) {
                         self.matchesTableView.hidden = YES;
                     }];
    [self updateMatches];
    [_matchesTableView reloadData];
}

- (int) indexByCountryName: (NSString*) name {
    int i = 0;
    while (![name isEqualToString:_countries[i]])
        i++;
    return i;
}

- (NSString*) countryCodeByCountryName: (NSString*) name {
    return _countryCodes[[self indexByCountryName:name]];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag) {
        MatchesMainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSArray* match = _matches[indexPath.row];
        cell.leftTeamName.text = match[0];
        cell.rightTeamName.text = match[1];
        cell.leftTeamLogo.layer.cornerRadius = cell.leftTeamLogo.layer.frame.size.height / 2.0;
        cell.rightTeamLogo.layer.cornerRadius = cell.rightTeamLogo.layer.frame.size.height / 2.0;
        cell.leftTeamLogo.image = [UIImage imageNamed:[self countryCodeByCountryName:(NSString*)match[0]]];
        cell.rightTeamLogo.image = [UIImage imageNamed:[self countryCodeByCountryName:(NSString*)match[1]]];
        cell.leftTeamLogo.layer.masksToBounds = YES;
        cell.rightTeamLogo.layer.masksToBounds = YES;
        
        cell.winProb1.text = [NSString stringWithFormat: @"%@ %%", match[2]];
        cell.winDraw.text = [NSString stringWithFormat: @"%@ %%", match[3]];
        cell.winProb2.text = [NSString stringWithFormat: @"%@ %%", match[4]];
        
        cell.matchDateLabel.text = match[5];
        cell.matchPlaceLabel.text = match[6];
        
        cell.stadiumTitle.text = match[7];
        cell.stadiumPlace.text = [NSString stringWithFormat:@"%@, Stadium", match[6]];
        
        cell.stadium.image = [UIImage imageNamed:match[7]];
        [cell.goToS7 addTarget:self action:@selector(openS7Website:) forControlEvents:UIControlEventTouchUpInside];
        cell.switchGo.on = [_switches[indexPath.row] boolValue];
        cell.switchGo.tag = indexPath.row;
        [cell.switchGo addTarget:self action:@selector(switcherEdited:)
                forControlEvents:UIControlEventValueChanged];
        cell.companionsButton.layer.cornerRadius = cell.companionsButton.frame.size.height/2.0;
        [cell.companionsButton addTarget:self action:@selector(openS7Website:) forControlEvents:UIControlEventTouchUpInside];
        if (cell.switchGo.on && [[NSUserDefaults standardUserDefaults] objectForKey:@"Go"]) {
            NSLog(@"NOOOO");
            cell.companionsButton.hidden = NO;
        } else {
            NSLog(@"YESSS");
            cell.companionsButton.hidden = YES;
        }
        return cell;
    }
    
    MatchesBeginFlagsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.chooseCountryLabel.text = _countries[indexPath.row];
    cell.chooseCountryImage.image = [UIImage imageNamed:_countryCodes[indexPath.row]];
    
    cell.chooseCountryImage.layer.cornerRadius = cell.chooseCountryImage.bounds.size.height / 2.0;
    cell.chooseCountryImage.layer.masksToBounds = YES;
    return cell;
}

- (void) switcherEdited: (UISwitch*) switcher {
    _switches[switcher.tag] = [NSNumber numberWithBool:!([_switches[switcher.tag] boolValue])];
    if ([_switches[switcher.tag] boolValue] && !_shown) {
        [self showAlert];
        _shown = TRUE;
    }
    [_matchesTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    _selectedCountryLabel.text = _countries[indexPath.row];
    _selectedCountryImageView.image = [UIImage imageNamed:_countryCodes[indexPath.row]];
    _selected = indexPath.row;
    [self.view setNeedsDisplay];
    [_countriesTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) openS7Website: (id) hhh {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.s7.ru"]];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag) {
        return 540;
    }
    return 70;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag) {
        return _matches.count;
    }
    return _countries.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag) {
        return 1;
    }
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
