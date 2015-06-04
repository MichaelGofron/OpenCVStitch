//
//  CVViewController.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2013 foundry. All rights reserved.
//

#import "CVViewController.h"
#import "CVWrapper.h"

@interface CVViewController ()

@end

@implementation CVViewController

- (void)viewDidAppear:(BOOL)animated    
{
    [super viewDidAppear:animated];
    [self stitch];
    [self.navigationController.navigationBar setHidden:NO];
}
- (IBAction)segueToCamera:(UIBarButtonItem *)sender {
    // segue back to original vc
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) stitch
{
    [self.spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // default project images
//        NSArray* imageArray = [NSArray arrayWithObjects:
//                               [UIImage imageNamed:@"pano_19_16_mid.jpg"]
//                               ,[UIImage imageNamed:@"pano_19_20_mid.jpg"]
//                               ,[UIImage imageNamed:@"pano_19_22_mid.jpg"]
//                               ,[UIImage imageNamed:@"pano_19_25_mid.jpg"]
//                               , nil];
        // Tested hardcoded images
//        NSArray *imageArray = [NSArray arrayWithObjects:
//                               [UIImage imageNamed:@"Library1.jpg"],
//                               [UIImage imageNamed:@"Library2.jpg"],
//                               nil];
        
        // Dynamic image acquisition
        NSArray* arr = @[@0,@1];
        NSArray* imageArray = [self retrieveAllImagesFromDefaultsWithKeys:(NSMutableArray*)arr];
        UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog (@"stitchedImage %@",stitchedImage);
            UIImageView* imageView = [[UIImageView alloc] initWithImage:stitchedImage];
            self.imageView = imageView;
            [self.scrollView addSubview:imageView];
            self.scrollView.backgroundColor = [UIColor blackColor];
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.scrollView.maximumZoomScale = 4.0;
            self.scrollView.minimumZoomScale = 0.2;
            self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
            NSLog (@"scrollview contentSize %@",NSStringFromCGSize(self.scrollView.contentSize));
            [self.spinner stopAnimating];
            
        });
    });
}

-(NSMutableArray *)convertPotraitToLandscape:(NSMutableArray *)Images{
    NSMutableArray *portraitImgs = [[NSMutableArray alloc]init];
    for (int p = 0; p < Images.count; p++){
        UIImage* LandscapeImage = Images[p];
        UIImage* PortraitImage = [[UIImage alloc] initWithCGImage: LandscapeImage.CGImage
                                                             scale: 1.0
                                                       orientation: UIImageOrientationLeft];
        [portraitImgs addObject:PortraitImage];
    }
    return portraitImgs;
}

-(UIImage *)retrieveImageFromDefaultsWithKey:(NSString *)objectKey{
    NSString *imagePath = [[NSUserDefaults standardUserDefaults] objectForKey:objectKey];
    UIImage *customImage = [UIImage imageWithContentsOfFile:imagePath];
    NSLog(@"customImage == %@",customImage);
    return customImage;
}

-(NSMutableArray *)retrieveAllImagesFromDefaultsWithKeys:(NSMutableArray *)keys{
    NSMutableArray* imgs = [[NSMutableArray alloc]init];
    for (int i = 0; i < keys.count; i++){
        NSString *key = [NSString stringWithFormat:@"test%d",i];
        NSLog(@"test%d",i);
        [imgs addObject:[self retrieveImageFromDefaultsWithKey:key]];
    }
    return imgs;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


@end
