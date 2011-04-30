//
//  Category.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/27/11.
//  Copyright (c) 2011 Harvard University Extension School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject * category;

@end
