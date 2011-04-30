//
//  PhotoViewController.h
//  MySoundImage
//
//  Created by Liangjun Jiang on 4/28/11.
//  Copyright 2011 Harvard University Extension School. All rights reserved.
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
