//
//  ViewController.m
//  Rustle
//
//  Created by Mike on 11/22/14.
//  Copyright (c) 2014 GOF Enterprises. All rights reserved.
//

// Rustle Imports
#import "CameraViewController.h"
#import "CustomImagePickerController.h"
#import "RustlesTableViewController.h"
#import "Constants.h"

// CV imports
#import "CVViewController.h"


@interface CameraViewController ()
@property CustomImagePickerController *PickerController;
@property CGFloat HeightOfButtons;
@property CGFloat CenterConst;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [self makeCustomCameraAppear];
    // advice from online
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)createCustomOverlayView{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    // Main overlay view created
    UIView *main_overlay_view = [[UIView alloc] initWithFrame:self.view.bounds];

    // Set up Camera Button
    self.HeightOfButtons = 40;
    CGFloat cameraWidth = self.view.frame.size.width/4;
    CGFloat cameraX = self.view.frame.size.width/2 - cameraWidth/2;
    CGFloat cameraY = self.view.frame.size.height-self.HeightOfButtons;
    
    // Clear view (live camera feed) created and added to main overlay view
    NSLog(@"%f",self.HeightOfButtons);
    UIView *clear_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.HeightOfButtons)];
    clear_view.opaque = NO;
    clear_view.backgroundColor = [UIColor clearColor];
    [main_overlay_view addSubview:clear_view];

    
    // Adding Camera Button
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // when a button is touched, CustomImagePickerController snaps a picture
    [cameraButton addTarget:self action:@selector(shootPicture) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.frame = CGRectMake(cameraX, cameraY, cameraWidth, self.HeightOfButtons);
        //button.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height - self.HeightOfButtons, self.view.frame.size.width / 4, self.HeightOfButtons);
    [cameraButton setBackgroundColor:[UIColor redColor]];
    [main_overlay_view addSubview:cameraButton];
    
    // Setup table Button
    CGFloat tableX = 0;
    CGFloat tableY = self.view.frame.size.height-self.HeightOfButtons;
    
    // Adding Table Button
    UIButton *tableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableButton addTarget:self action:@selector(segueToRustlesTableViewController) forControlEvents:UIControlEventTouchUpInside];
    tableButton.frame = CGRectMake(tableX, tableY, cameraWidth, self.HeightOfButtons);
    [tableButton setBackgroundColor:[UIColor blueColor]];// Use BackgroundImage later
    [main_overlay_view addSubview:tableButton];
    
    // Setup panaroma button
    CGFloat panaromaX = self.view.frame.size.width - cameraWidth; // set to some position at far right
    CGFloat panaromaY = tableY; // set to same as the table Button
    
    // adding panaroma view
    UIButton *panaromaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [panaromaButton addTarget:self action:@selector(segueToCVImageController) forControlEvents:UIControlEventTouchUpInside];
    panaromaButton.frame = CGRectMake(panaromaX, panaromaY, cameraWidth, self.HeightOfButtons);
    [panaromaButton setBackgroundColor:[UIColor greenColor]];// Use BackgroundImage later
    [main_overlay_view addSubview:panaromaButton];
    
    return main_overlay_view;
}

-(void)segueToRustlesTableViewController{
    
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    //RustlesTableViewController* rustlesVC = [[RustlesTableViewController alloc]init];
    //[self.PickerController presentViewController:rustlesVC animated:NO completion:nil];
    
    // Instantiate nav controller which segues to table view
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]; // must assume only IPhone
    RustlesTableViewController *rustlesTVC = (RustlesTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"RustlesNavigation"];
    [self.PickerController presentViewController:rustlesTVC animated:YES completion:nil];
}

-(void)segueToCVImageController{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    // Instantiate nav controller which segues to CV View Controller (stitched Image display)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]; // must assume only IPhone
    CVViewController *CVController = (CVViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CVView"];
    [self.PickerController presentViewController:CVController animated:YES completion:nil];
}

- (void)makeCustomCameraAppear
{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    self.PickerController = [[CustomImagePickerController alloc] init];
    self.PickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.PickerController.showsCameraControls = NO;
    self.PickerController.delegate = self;
    
    UIView *overlay_view = [self createCustomOverlayView];
    [self.PickerController setCameraOverlayView:overlay_view];
    
    [self presentViewController:self.PickerController animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    // Now do something with pickedImage
    UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil);
}

-(void)shootPicture{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [self.PickerController takePicture];
}

@end
