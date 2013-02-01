//
//  ACAddressBookDataSource.m
//  AutoCompleteCell
//
//  Created by Felipe Saint Jean on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ACAddressBookDataSource.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@implementation ACAddressBookElement
@synthesize first_name;
@synthesize last_name;
@synthesize email;


-(NSString *)getDisplayText{
    
    if (self.first_name && self.last_name && self.email)
        return [NSString stringWithFormat:@"%@ %@ <%@>",self.first_name,self.last_name,self.email];
    else if (self.first_name)
        return [NSString stringWithFormat:@"%@ <%@>",self.first_name,self.email];
    else 
        return self.email; 
    
}
-(void)dealloc{
    [first_name release];
    [last_name release];
    [email release];
    [super dealloc];
}
    
@end


@implementation ACAddressBookDataSource

- (void)filterContentForSearchText:(NSString*)searchText {
	
	[filtered removeAllObjects]; 	
    
	for (int i=0; i<[contacts count]; i++) {
		
		ABRecordRef contact =  [contacts objectAtIndex:i];
		
        NSString *lastName,*firstName;
        lastName  = (NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
        firstName  = (NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
			
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF contains[cd] %@)", searchText];
        
        
        
        BOOL resultFN = [predicate evaluateWithObject:firstName];
        BOOL resultLN = [predicate evaluateWithObject:lastName];
         
        
        
        
        if(resultFN || resultLN) {
            // Add All emails
            ABMultiValueRef emails = ABRecordCopyValue(contact, kABPersonEmailProperty);
            int count = ABMultiValueGetCount(emails);
            for (int email_index = 0;email_index<count;email_index++){
                ACAddressBookElement *el = [[ACAddressBookElement alloc] init];
                el.first_name = firstName;
                el.last_name = lastName ;
                el.email =  ABMultiValueCopyValueAtIndex(emails,email_index);
                [filtered addObject:el];
            }
        }	
    }
}



-(id)init{
    self = [super init];
    if (self){
        contacts = [[NSMutableArray alloc] init];
        filtered = [[NSMutableArray alloc] init];
        
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        contacts = (NSMutableArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
       // [contacts sortUsingFunction:(int(*)(id, id, void*))ABPersonComparePeopleByName context:(void*)ABPersonGetSortOrdering()];

    }
    return self;
}

-(void)cancel{

}
-(void)getSuggestionsFor:(NSString *)searchString withCallback:(void (^)(NSArray *suggestions))update{
    [self filterContentForSearchText:searchString];
    update(filtered);
    
}

-(void)dealloc{
    [contacts release];
    [filtered release];
    [super dealloc];
}
@end
