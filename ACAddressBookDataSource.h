//
//  ACAddressBookDataSource.h
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACTextArea.h"

@interface ACAddressBookElement : NSObject <ACAutoCompleteElement> {
    NSString *first_name;
    NSString *last_name;
    NSString *email;
    
}
@property (nonatomic, readwrite, retain) NSString *first_name;
@property (nonatomic, readwrite, retain) NSString *last_name;
@property (nonatomic, readwrite, retain) NSString *email;
@end

@interface ACAddressBookDataSource : NSObject <ACAutoCompleteDataSource>{

    NSMutableArray *contacts;
    NSMutableArray *filtered;
}

@end
