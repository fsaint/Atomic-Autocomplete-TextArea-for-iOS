//
//  ACViewController.h
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACTextArea.h"
@interface ACViewController : UIViewController{
    ACTextArea *textArea;
}

@property (nonatomic, readwrite, retain) IBOutlet ACTextArea *textArea;
@end
