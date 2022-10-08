//
//  RClass.h
//  RuntimeC
//
//  Created by Nikita Skrypchenko on 06.09.2022.
//

#import <Foundation/Foundation.h>


@interface Image : NSObject
{
    NSURL *imageURL;
}
@end

@interface CatInBox : NSObject
{
    Image * _image;
    
}
@property (class, nonatomic, assign, readonly) NSInteger userCount;
@property (class, nonatomic, copy) NSUUID *identifier;
@property NSString* name;
@property Image* image;
+ (void)resetIdentifier;
+ (CatInBox *)getUser;
+ (BOOL) isInLoveWithBoxes;

@end

