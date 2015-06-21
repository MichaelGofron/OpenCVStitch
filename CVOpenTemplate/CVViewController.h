//
//  CVViewController.h
//  CVOpenTemplate
//
//  Created by Washe on 02/01/2013.
//  Copyright (c) 2014 GOF Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingDataViewController.h"

@interface CVViewController : SavingDataViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@end
