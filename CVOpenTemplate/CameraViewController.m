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
#import "Constants.h"
#import "SettingsViewController.h"

// Framework imports
#import <QuartzCore/QuartzCore.h>

// CV imports
#import "CVViewController.h"


@interface CameraViewController ()
@property CustomImagePickerController *PickerController;
@property CGFloat HeightOfButtons;
@property CGFloat CenterConst;
@end

double compressPhotoTo720From2448 = 0.29411764705882;
const int numberOfImagesUserCanSave = 10;

@implementation CameraViewController

- (void)viewDidLoad {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [self setDefaultPhotoIndx];
    [super viewDidLoad];
}

-(void)setDefaultPhotoIndx{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"photoIndx"]){
        [defaults setObject:[[NSNumber alloc]initWithInt:0] forKey:@"photoIndx"];
    }
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
    NSLog(@"self.view.bounds == %@",NSStringFromCGRect(self.view.bounds));
    
    // Set up Camera Button
    self.HeightOfButtons = self.view.frame.size.width/5;
    CGFloat cameraWidth = self.view.frame.size.width/5;
    CGFloat cameraX = self.view.frame.size.width/2 - cameraWidth/2;
    CGFloat cameraY = self.view.frame.size.height-self.HeightOfButtons;
    
    // Clear view (live camera feed) created and added to main overlay view
    NSLog(@"%f",self.HeightOfButtons);
    UIView *clear_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    NSLog(@"self.view.frame.size.width == %f, self.view.frame.size.height == %f",self.view.frame.size.width,self.view.frame.size.height);
    clear_view.opaque = NO;
    clear_view.backgroundColor = [UIColor clearColor];
    [main_overlay_view addSubview:clear_view];
    
    
    // Adding Camera Button
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // when a button is touched, CustomImagePickerController snaps a picture
    [cameraButton addTarget:self action:@selector(shootPicture) forControlEvents:UIControlEventTouchUpInside];
    cameraButton.frame = CGRectMake(cameraX, cameraY, cameraWidth, self.HeightOfButtons);
    [cameraButton setBackgroundColor:[UIColor whiteColor]];
    cameraButton.layer.cornerRadius = cameraButton.bounds.size.width / 2.0;
    [main_overlay_view addSubview:cameraButton];
    
    // Setup settings Button
    CGFloat settingsX = 0;
    CGFloat settingsY = self.view.frame.size.height-self.HeightOfButtons;
    
    // Adding Settings Button
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton addTarget:self action:@selector(segueToSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
    UIImage *settingsBtnImage = [UIImage imageNamed:@"gear-iconWithStroke"];
    [settingsButton setImage:settingsBtnImage forState:UIControlStateNormal];
    settingsButton.frame = CGRectMake(settingsX, settingsY, cameraWidth, self.HeightOfButtons);
    [main_overlay_view addSubview:settingsButton];
    
    
    // Setup stitching button
    CGFloat stitchingX = self.view.frame.size.width - cameraWidth; // set to some position at far right
    CGFloat stitchingY = settingsY; // set to same as the table Button, we should set the stitching y to be on equal level
    
    // adding stitching view
    UIButton *stitchingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stitchingButton addTarget:self action:@selector(segueToCVImageController) forControlEvents:UIControlEventTouchUpInside];
    UIImage *stitchingBtnImage = [UIImage imageNamed:@"sNeedle120"];
    [stitchingButton setImage:stitchingBtnImage forState:UIControlStateNormal];
    stitchingButton.frame = CGRectMake(stitchingX, stitchingY, cameraWidth, self.HeightOfButtons);
    [main_overlay_view addSubview:stitchingButton];
    
    return main_overlay_view;
}

-(void)segueToSettingsViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]; // must assume only IPhone
    SettingsViewController *settingsVC = (SettingsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SettingsNavigation"];
    [self.PickerController presentViewController:settingsVC animated:YES completion:nil];
}

-(void)logCompleted{
    NSLog(@"completed");
}

-(void)segueToCVImageController{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    // Instantiate nav controller which segues to CV View Controller (stitched Image display)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]; // must assume only IPhone
    CVViewController *CVController = (CVViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CVNavigation"];
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
    pickedImage = [self compressForUpload:pickedImage scale:compressPhotoTo720From2448];
    //    UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil);
    [self saveImageToDefaults:pickedImage];
}

// Photo must now not go to photo album but instead local memory for app
// then reference those photos in image stitching section in CVViewController stitch method
-(void)shootPicture{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    [self.PickerController takePicture];
}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

-(void)saveImageToDefaults:(UIImage *)newImage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0); // Used to be PNG
    
    // creates a list of path strings in the specified directory in the specified domains, if tildes they expand
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // first path string
    
    int photoIndx = [[defaults objectForKey:@"photoIndx"]intValue];
    if (photoIndx < numberOfImagesUserCanSave){
        NSString *imgKey = [NSString stringWithFormat:@"test%d",photoIndx];
        
        NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imgKey]]; // create path for image by appending strings
        
        [self writeToFileWith:imagePath andData:imageData];
        
        NSLog(@"test%d",photoIndx);
        
        [defaults setObject:imagePath forKey:imgKey];
        photoIndx++; // increment photoIndex for next pass
        [defaults setObject:[[NSNumber alloc]initWithInt:photoIndx] forKey:@"photoIndx"];
    }
}

-(void)writeToFileWith:(NSString*)imagePath
               andData:(NSData*)imageData{
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO]){
        NSLog((@"Failed to cache image data to disk"));
    }
    else{
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
}

@end
