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
        text_label.backgroundColor = [UIColor lightGrayColor];
        text_label.textColor = [UIColor whiteColor];
        [self addSubview:text_label];
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.layer.cornerRadius = 5.0;
        
        // delete button
        delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete_button setImage:[UIImage imageNamed:@"37-circle-x.png"] forState:UIControlStateNormal];
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
        self.backgroundColor = [UIColor darkGrayColor];
        
    }
    else{
        self.backgroundColor = [UIColor lightGrayColor];
    }
    text_label.backgroundColor = self.backgroundColor;
        
}

-(void)setFont:(UIFont *)font{
    text_label.font = font;
}
-(void)layoutSubviews{
    
    CGRect frame = self.bounds;
    CGRect tr =  CGRectInset(self.bounds, 1.0, 1.0);
    tr.size.width = tr.size.width- frame.size.height;
    text_label.frame = tr;
    
    delete_button.frame = CGRectInset(CGRectMake(frame.size.width - frame.size.height, 0.0, frame.size.height, frame.size.height),4.0,4.0);

}

-(void)setLabelText:(NSString *)s{
    text_label.text = s;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
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
