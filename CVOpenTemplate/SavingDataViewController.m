//
//  SavingDataViewController.m
//  CVOpenStitch
//
//  Created by Mike on 6/8/15.
//  Copyright (c) 2015 foundry. All rights reserved.
//

#import "SavingDataViewController.h"

@interface SavingDataViewController ()

@end

@implementation SavingDataViewController

const int initialNumPhotos = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// determine whether the number of images matches what the settings say
-(BOOL)numberOfImagesMatchesSettings{
    NSString* strNumPhotos = [[NSUserDefaults standardUserDefaults]objectForKey:@"NumPhotos"];
    int numPhotos = (int)[strNumPhotos integerValue];
    return [self enoughImagesTaken:numPhotos];
}


-(NSArray*)returnDynamicallyTakenImageArray{
    NSString* strNumPhotos = [self initializeNumberOfPhotos];
    int numPhotos = (int)[strNumPhotos integerValue];
    NSArray* imageArray = [self retrieveAllImagesFromDefaultsWith:numPhotos];
    return imageArray;
}

// Must account for the fact that previous uses of app could cause user to set the number of photos differently
-(NSString *)initializeNumberOfPhotos{
    NSString *strNumPhotos = [[NSUserDefaults standardUserDefaults]objectForKey:@"NumPhotos"];
    NSLog(@"%@",strNumPhotos);
    if (!strNumPhotos){ // nothing in user defaults
        // set default number of photos needed to stitch
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",initialNumPhotos] forKey:@"NumPhotos"];
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"NumPhotos"];
}

-(UIImage *)retrieveImageFromDefaultsWithKey:(NSString *)objectKey{
    NSString *imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:objectKey];
    UIImage *customImage = [UIImage imageNamed:imagePath];
    //    UIImage *customImage = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@"customImage == %@",customImage);
    return customImage;
}

// keys is a simple placeholder for when refactoring this code to allow more variable ways to stitch images
-(NSMutableArray *)retrieveAllImagesFromDefaultsWith:(int)numPhotos{
    NSMutableArray* imgs = [[NSMutableArray alloc]init];
    for (int i = 0; i < numPhotos; i++){
        NSString *key = [NSString stringWithFormat:@"test%d",i];
        NSLog(@"test%d",i);
        UIImage *image = [self retrieveImageFromDefaultsWithKey:key];
        [imgs addObject:image];
    }
    return imgs;
}

-(BOOL)enoughImagesTaken:(int)numPhotos{
    for (int i = 0; i < numPhotos; i++){
        NSString *key = [NSString stringWithFormat:@"test%d",i];
        UIImage *image = [self retrieveImageFromDefaultsWithKey:key];
        if (!image)
            return false;
    }
    return true;
}

// Original image array from foundry's stitching repo
-(NSArray *)returnOrigImageArray{
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"pano_19_16_mid.jpg"]
            ,[UIImage imageNamed:@"pano_19_20_mid.jpg"]
            ,[UIImage imageNamed:@"pano_19_22_mid.jpg"]
            ,[UIImage imageNamed:@"pano_19_25_mid.jpg"]
            , nil];
}

-(NSArray*)returnManuallyAddedImageArray{
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"Library1.jpg"],
            [UIImage imageNamed:@"Library2.jpg"],
            nil];
}

-(NSArray*)returnAManuallyAddedImageArray{
    return [NSArray arrayWithObjects:
            [UIImage imageNamed:@"LibraryGirl1.jpg"],
            [UIImage imageNamed:@"LibraryGirl2.jpg"],
            nil];
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
