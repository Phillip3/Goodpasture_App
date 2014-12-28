//
//  FlickrPhotoCell.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/16/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "FlickrPhotoCell.h"

@implementation FlickrPhotoCell
@synthesize imageData = _imageData;
-(void) setImageData:(NSData *)imageData
{
    _imageData = imageData;
    [self setNeedsDisplay];
}
-(NSData *) imageData
{
    if (!_imageData) {
        _imageData = [[NSData alloc] init];
    }
    return _imageData;
}

@synthesize url = _url;
-(void) setUrl:(NSURL *)url
{
    _url= url;
    [self getPhoto];
}
-(NSURL *) url
{
    if (!_url) {
        _url = [[NSURL alloc] init];
    }
    return _url;
}
@synthesize black=_black;
-(BOOL) black
{
    if (!_black) {
        _black = NO;
    }
    return _black;
}
-(void) setBlack:(BOOL)black
{
    if (black) {
        self.imageData = [[NSData alloc] initWithContentsOfFile:@"default.jpg"];
        [self setNeedsDisplay];
    }
}



-(void) getPhoto
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Getting Photo", NULL);
    dispatch_async(fetchQ, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        NSData *photoData = [[NSData alloc] initWithContentsOfURL:self.url];
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.imageData) {
        // Drawing code
        UIImage *image = [UIImage imageWithData:self.imageData];
        [image drawInRect:self.bounds];
    }
}


@end
