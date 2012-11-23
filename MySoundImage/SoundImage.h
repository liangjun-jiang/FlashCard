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
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * soundPath;
@property (nonatomic, strong) NSString * imagePath;
@property (nonatomic, strong) NSString * voicePath;
@property (nonatomic, strong) NSString * comment;
@property (nonatomic, strong) Category * category;

@end
