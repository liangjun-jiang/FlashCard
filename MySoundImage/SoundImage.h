//
//  SoundImage.h
//  MySoundImage
//
//  Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface SoundImage : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * soundPath;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * voicePath;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) Category * category;

@end
