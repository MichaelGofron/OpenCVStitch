//
//  CVViewController.m
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2014 GOF Enterprises. All rights reserved.
//

#import "CVViewController.h"
#import "CVWrapper.h"
#import "Constants.h"

@interface CVViewController ()
@property (strong, nonatomic) IBOutlet UILabel *enoughImages;
@property UIImagePickerController *PickerController;
@end

@implementation CVViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self makeCameraRollAppear];
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
        
        // NSArray *imageArray = [self returnOrigImageArray];
        
        // Tested hardcoded images captured using iphone camera and manually added to resource bundle
        //        NSArray *imageArray = [self returnManuallyAddedImageArray];
        
        //        NSArray *imageArray = [self returnAManuallyAddedImageArray];
        // Dynamic image acquisition with only 2 images allowed
        // Must take two images using the red button at camera screen or program will crash if
        // using the below lines for dynamic image stitching
        
        if ([self numberOfImagesMatchesSettings]){ // check that number of images matches the settings
            NSArray *imageArray = [self returnDynamicallyTakenImageArray];
            NSLog(@"imageArray = %@",imageArray);
            UIImage* stitchedImage = [CVWrapper processWithArray:imageArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog (@"stitchedImage %@",stitchedImage);
                UIImageView* imageView = [[UIImageView alloc] initWithImage:stitchedImage];
                UIImageWriteToSavedPhotosAlbum(stitchedImage, nil, nil, nil);
                self.imageView = imageView;
                [self.scrollView addSubview:imageView];
                self.scrollView.backgroundColor = [UIColor blackColor];
                self.scrollView.contentSize = self.imageView.bounds.size;
                self.scrollView.maximumZoomScale = 4.0;
                self.scrollView.minimumZoomScale = 0.5;
                self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
                NSLog (@"scrollview contentSize %@",NSStringFromCGSize(self.scrollView.contentSize));
                
            });
        }else{
            NSLog(@"Not enough images taken");
        }
        [self.spinner stopAnimating];
        return;
    });
    [self.spinner stopAnimating];
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
