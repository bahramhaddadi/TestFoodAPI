//
//  ImageCacheManager.h
//  TestFoodAPI
//
//  Created by Bahram Haddadi on 2016-03-22.
//  Copyright © 2016 Bahram Haddadi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ImageLoadCallBack) (UIImage* image, NSError *error);

@interface ImageCacheManager : NSObject

+(ImageCacheManager*)sharedInstance;

-(void)loadImage:(NSString*)url complition:(ImageLoadCallBack)complition;
-(void)cacheImage:(UIImage*)image name:(NSString*)name;

@end
