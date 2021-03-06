//
//  TotalPointsViewController.m
//  QuizMasterGame
//
//  Created by Jack Leon on 11/6/14.
//  Copyright (c) 2014 PauloCoelho. All rights reserved.
//

#import "TotalPointsViewController.h"
#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"
#import "CustomTableViewCell.h" 

@interface TotalPointsViewController ()

@end

@implementation TotalPointsViewController

- (instancetype)init {
  self = [super init];
  if (self) {
    self.usersData = [NSArray array];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    self.usersData = [NSArray array];
  }

  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.usersData = [NSArray array];
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(tappedRightButton:)];
  [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:swipeLeft];

  UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(tappedLeftButton:)];
  [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
  [self.view addGestureRecognizer:swipeRight];

  [self.tableView setDataSource:self];

  [self getData];
}

- (IBAction)tappedRightButton:(id)sender {
  NSUInteger selectedIndex = [self.tabBarController selectedIndex];

  [self.tabBarController setSelectedIndex:selectedIndex + 1];
}

- (IBAction)tappedLeftButton:(id)sender {
  NSUInteger selectedIndex = [self.tabBarController selectedIndex];

  [self.tabBarController setSelectedIndex:selectedIndex - 1];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)getData {
    __weak id weakSelf = self;
    PFQuery *query = [PFUser query];
    [query orderByDescending:@"points"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [weakSelf setUsersData: [NSMutableArray arrayWithArray:objects]];
        [[weakSelf tableView] reloadData];
    }];

}

#pragma mark - Table View Data source**************
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.usersData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"Cell";

  CustomTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (cell == nil) {
    cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:cellIdentifier];
  }

    PFUser *userData = (PFUser *)[self.usersData objectAtIndex:indexPath.row];

    // Image
    PFFile *imageFile = [userData objectForKey:@"image"];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageFile.url]
                      placeholderImage:[UIImage imageNamed:@"avatr.png"]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Label
    NSMutableString *cellContent = [NSMutableString string];
    
    NSString *points = [NSString stringWithFormat:@"%@ %@", [userData objectForKey:@"points" ], @"points"];
    
    [cellContent appendFormat:@"%ld. %@", (long)indexPath.row + 1, userData.username];

    
    cell.textLabel.text = cellContent;
    cell.detailTextLabel.text = points;

    return cell;
}

@end
