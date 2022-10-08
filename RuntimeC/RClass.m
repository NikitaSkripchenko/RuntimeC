//
//  RClass.m
//  RuntimeC
//
//  Created by Nikita Skrypchenko on 06.09.2022.
//

#import <Foundation/Foundation.h>
#import "RClass.h"

@implementation Image

- (instancetype)init
{
    self = [super init];
    NSURL *url = [NSURL URLWithString:@"https://i.imgur.com/yKlr83v.jpeg"];
    imageURL = url;
    return self;
}

@end

@implementation CatInBox
static NSUUID *_identifier = nil;
static NSInteger _userCount = 0;


+ (NSInteger) userCount {
    return _userCount;
}

+ (NSUUID *)identifier {
    if (_identifier == nil) {
        _identifier = [[NSUUID alloc] init];
    }
    return _identifier;
}

+ (void)setIdentifier:(NSUUID *)newIdentifier {
    if (newIdentifier != _identifier) {
        _identifier = [newIdentifier copy];
    }
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _userCount += 1;
  }
  return self;
}

+ (void)resetIdentifier {
  _identifier = [[NSUUID alloc] init];
}




+ (CatInBox *)getUser {
    CatInBox * cat = [[CatInBox alloc] init];
    cat.name = @"Wisp";
    
    Image* image = [[Image alloc] init];
    
    [cat setImage:image];// = image;
    return cat;
}

+ (BOOL) isInLoveWithBoxes {
    return TRUE;
}

@end
