//
//  HomeCellView.m
//  Goodpasture Application
//
//  Created by Phillip Trent on 7/5/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//

#import "HomeCellView.h"
@interface HomeCellView()
@property (nonatomic) CGFloat circleStrokeWidth;
@end

@implementation HomeCellView
-(NSString *) name
{
    if (!_name) {
        _name = [[NSString alloc] init];
    }
    return _name;
}
-(void) setup
{
    //do initialization here
    NSLog(@"setup");
    self.alpha = 1.0;
    self.highlighted = NO;
    self.tapped = NO;
    self.circleStrokeWidth = self.frame.size.width/140.0;
    [self setNeedsDisplay];
}
-(void)setTapped:(BOOL)tapped
{
    _tapped = tapped;
    if(tapped) self.alpha = 0.6;
    [self setNeedsDisplay];
}
-(void) fadeToSolid
{
    NSLog(@"fadeToSolid");

    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
}
-(void) awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    NSLog(@"initWithFrame");
    return self;
}
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect");
    //calculate the rectangle
    CGRect calculatedRect = rect;
    
    //draw the label
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat centerx = calculatedRect.origin.x + (calculatedRect.size.width/2);
    CGFloat centery = calculatedRect.origin.y + (calculatedRect.size.height/2);
    titleLabel.text = self.name;
    titleLabel.textColor = self.circleStrokeColor;
    CGFloat fontSize = (self.frame.size.width/120) * [UIFont systemFontSize];
    titleLabel.font = [UIFont fontWithDescriptor:[[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline] fontDescriptor] size:fontSize];
    
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(centerx, centery);

    
    //draw the circle
    CGFloat strokeWidth = self.circleStrokeWidth;
    CGFloat halfStrokeWidth = strokeWidth/2;
    
    CGFloat circleOriginX = calculatedRect.origin.x + halfStrokeWidth;
    CGFloat circleOriginY = calculatedRect.origin.y + halfStrokeWidth;
    CGFloat circleWidth = calculatedRect.size.width - strokeWidth;
    CGFloat circleHeight = calculatedRect.size.width - strokeWidth;
    
    UIBezierPath *circlePath;
    
    circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(circleOriginX, circleOriginY, circleWidth, circleHeight)];
    
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.lineWidth = strokeWidth;
    circleLayer.lineWidth = self.circleStrokeWidth;
    circleLayer.strokeColor = self.circleStrokeColor.CGColor;
    circleLayer.fillColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    circleLayer.path = circlePath.CGPath;
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = CGPathCreateWithEllipseInRect(calculatedRect, nil);
    
    //draw label and circle inside self
    [self.layer addSublayer:circleLayer];
    [self addSubview:titleLabel];
    self.layer.mask = maskLayer;
    
}
@end
