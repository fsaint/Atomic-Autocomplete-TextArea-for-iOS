//
//  ACArrayDataSource.h
//  AutoCompleteCell
//
//  Created by Felipe Saint-Jean on 1/21/14.
//
//

#import <Foundation/Foundation.h>
#import "ACTextArea.h"

@interface ACDictionaryObject : NSObject
@property (nonatomic,strong) NSDictionary *values;
@property (nonatomic,strong) NSString *display_key;



@end
@interface ACArrayDataSource : NSObject <ACAutoCompleteDataSource>
-(id)initWithObjects:(NSArray *)arr displayKey:(NSString *)display_key;
@property (nonatomic,strong) NSString *display_key;
@property (nonatomic,strong) NSArray *search_keys;
@property (nonatomic,strong) NSArray *objects;

@end
