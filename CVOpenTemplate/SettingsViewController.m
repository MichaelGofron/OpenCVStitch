//
//  SettingsViewController.m
//  CVOpenStitch
//
//  Created by Mike on 6/6/15.
//  Copyright (c) 2015 foundry. All rights reserved.
//

#import "SettingsViewController.h"
#import "CameraViewController.h"

@interface SettingsViewController ()
{
    NSArray *pickerData;
}

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializePickerData];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segueToCamera:(UIBarButtonItem *)sender {
    // segue back to original vc
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initializePickerData{
    pickerData = @[@2,@3,@4,@5,@6,@7,@8,@9];
}

// might want to also remove any instances of previously stitched photos
- (IBAction)resetPhotos:(UIButton *)sender {
    NSLog(@"resetted photos");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *photoIndx = [defaults objectForKey:@"photoIndx"];
    [self removePreviousPhotos:photoIndx];
    NSNumber *newPhotoIndx = [[NSNumber alloc]initWithInt:0];
    [[NSUserDefaults standardUserDefaults]setObject:newPhotoIndx forKey:@"photoIndx"];
}

// test by taking a number of photos, resetting, then stitching
-(void)removePreviousPhotos:(NSNumber*)photoIndx{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int intPhotoIndx = [photoIndx intValue];
    for (int i = 0; i < intPhotoIndx; i++){
        NSString *key = [NSString stringWithFormat:@"test%d",i];
        [defaults setObject:nil forKey:key]; // reset all objects to nothing
    }
}

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",pickerData[row]];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    [[NSUserDefaults standardUserDefaults] setObject:[pickerData objectAtIndex:row] forKey:@"NumPhotos"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
