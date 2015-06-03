//
//  RustlesTableViewController.m
//  Rustle
//
//  Created by Mike on 11/22/14.
//  Copyright (c) 2014 GOF Enterprises. All rights reserved.
//

#import "RustlesTableViewController.h"
#import "PhotoCell.h"
#import "Constants.h"

@implementation RustlesTableViewController

- (void)viewDidLoad {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    [super viewDidLoad];
    NSLog(@"self.navController == %@",self.navigationController);
    [self.tableView registerClass:[PhotoCell class] forCellReuseIdentifier:@"PhotoCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (IBAction)segueToCamera:(UIBarButtonItem *)sender {
    // segue back to original vc
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

@end
