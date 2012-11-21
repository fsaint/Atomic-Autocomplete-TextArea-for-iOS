//
//  ACBubble.m
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ACBubble.h"
#import <QuartzCore/QuartzCore.h>
#import "ACTextArea.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



#define BCONTEXT_ORANGE UIColorFromRGB(0xF16923)


@implementation ACBubble
@synthesize textarea;
@synthesize selected;
@synthesize ac_background_color;
@synthesize ac_text_color;
@synthesize ac_background_selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // text label
        text_label = [[UILabel alloc] initWithFrame:CGRectZero];
        text_label.backgroundColor = [UIColor clearColor];
        text_label.textColor = [UIColor whiteColor];
        text_label.textAlignment = UITextAlignmentRight;
        [self addSubview:text_label];
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 5.0;
        
        // delete button
        delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete_button setImage:[UIImage imageNamed:@"close@2x"] forState:UIControlStateNormal];
        [delete_button retain];
        delete_button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
        [delete_button addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delete_button];
        
        self.selected = NO;
        
    }
    return self;
}

-(void)setSelected:(BOOL)sel{
    selected = sel;
    if (sel){
        self.backgroundColor = [UIColor clearColor];
        
    }
    else{
        self.backgroundColor = [UIColor clearColor];
    }
    text_label.backgroundColor = self.backgroundColor;
        
}

-(void)setFont:(UIFont *)font{
    text_label.font = font;
}
-(void)layoutSubviews{
    
    CGRect frame = self.bounds;
    CGRect tr =  CGRectInset(self.bounds, 1.0, 1.0);
    tr.size.width = tr.size.width - frame.size.height;
    text_label.frame = tr;
       
    delete_button.frame = CGRectInset(CGRectMake(frame.size.width - frame.size.height, 0.0, frame.size.height, frame.size.height),4.0,4.0);
    
    CGRect labelRect = text_label.frame;
    labelRect.size.width = labelRect.size.width + (delete_button.frame.origin.x - labelRect.size.width)/2;
    text_label.frame = labelRect;
}

-(void)setLabelText:(NSString *)s{
    text_label.text = s;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat radius = CGRectGetHeight(self.bounds) / 1.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    
    NSArray *colors = nil;
   
        colors = [NSArray arrayWithObjects:
                  ( id)BCONTEXT_ORANGE.CGColor,
                  ( id)BCONTEXT_ORANGE.CGColor,
                  nil];
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, ( CFTypeRef)colors, NULL);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawLinearGradient(ctx, gradient, CGPointZero, CGPointMake(0, CGRectGetHeight(self.bounds)), 0);
    CGGradientRelease(gradient);
    CGContextRestoreGState(ctx);
    
    [BCONTEXT_ORANGE set];
    
    
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 1.0, 1.0) cornerRadius:radius];
    [path setLineWidth:1.0];
    [path stroke];
}

-(void)deleteButtonPressed:(UIButton *)b{
    [textarea deleteItemWithBubble:self];
}
-(void)dealloc{
    
    [ac_background_color release];
    [ac_text_color release];
    [ac_background_selected release];
    [ac_background_color release];
    [ac_text_color release];
    [ac_background_selected release];
    [textarea release];
    [delete_button release];
    [text_label release];
    [super dealloc];
}

@end
