//
//  PhotoViewController.h
//  MySoundImage
//   
//  This class is used to display the selected image/photo
// We don't really implement it yet.
//
// Created by Liangjun Jiang  on 4/27/11.
//  Apple ID: ljiang510@gmail.com
//  Copyright 2011 LJSport Apps. LLC. All rights reserved.


//  
// 
// 

#import <UIKit/UIKit.h>
@class  SoundImage;

@interface PhotoViewController : UIViewController {
    @private
    SoundImage *soundImage;
    UIImageView *imageView;
}

@property(nonatomic, retain) SoundImage *soundImage;
@property(nonatomic, retain) UIImageView *imageView;

@end
