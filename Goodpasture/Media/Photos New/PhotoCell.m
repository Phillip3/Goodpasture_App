//
//  PhotoCell.m
//  Goodpasture
//
//  Created by Phillip Trent on 7/17/14.
//  Copyright (c) 2014 Phillip Trent Coding. All rights reserved.
//

#import "PhotoCell.h"
@interface PhotoCell () <UIScrollViewDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UIImageView *imageView;
@end
@implementation PhotoCell
-(void)setPhotoURL:(NSURL *)photoURL
{
    _photoURL = photoURL;
    [self fetchPhotoData];
}
-(void) setImageData:(NSData *)imageData
{
    _imageData = imageData;
    self.black = NO;
}
-(void)setBlack:(BOOL)black
{
    _black = black;
    [self setNeedsDisplay];
}
-(void)fetchPhotoData
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Getting Photo", NULL);
    dispatch_async(fetchQ, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        NSData *photoData = [[NSData alloc] initWithContentsOfURL:self.photoURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            self.imageData = photoData;
        });
    });
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for (UIView *subview in self.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
    if (!self.black) {
        UIImage *image = [UIImage imageWithData:self.imageData];
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.imageView setImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.center = self.contentView.center;
        self.contentView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
    } else {
        self.backgroundColor = [UIColor blackColor];
    }
}


@end
