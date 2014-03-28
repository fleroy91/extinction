//
//  GameCell.m
//  ToDoList
//
//  Created by Frédéric Leroy on 06/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import "GameCell.h"

@implementation GameCell

- (id)init:(enum CELL_KIND)kind
{
    self = [super init];
    if (self) {
        self.kind = kind;
        self.water_kind = none;
        self.image = NULL;
    }
    return self;
}

+ (NSInteger)nbKinds {
    return 13;
}
+ (NSInteger)nbKindsForCells {
    return 9;
}
+ (NSInteger)nbKindsForWater {
    return 3;
}

- (UIImage *)getImage;
{
    if(! self.image) {
        self.image = [UIImage imageNamed:self.imageName];
    }
    return self.image;
}

- (Boolean)isWater {
    return (self.kind == water_both || self.kind == water_left || self.kind == water_right);
}

- (Boolean)isFire {
    return (self.kind == fire);
}

- (Boolean)canExitRight;
{
    Boolean ret;
    switch (self.kind) {
        case cross:
        case left_right:
        case water_both:
        case water_right:
        case through:
        case y_inv_left:
        case y_inv_right:
        case y_right:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}
- (Boolean)canExitLeft
{
    Boolean ret;
    switch (self.kind) {
        case cross:
        case right_left:
        case water_both:
        case water_left:
        case through:
        case y_inv_left:
        case y_inv_right:
        case y_left:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}
- (Boolean)canInputLeft
{
    Boolean ret;
    switch (self.kind) {
        case fire:
        case cross:
        case left_right:
        case water_both:
        case water_right:
        case water_left:
        case through:
        case y_inv_left:
        case y_right:
        case y_left:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}
- (Boolean)canInputRight
{
    Boolean ret;
    switch (self.kind) {
        case fire:
        case cross:
        case right_left:
        case water_both:
        case water_right:
        case water_left:
        case through:
        case y_inv_right:
        case y_right:
        case y_left:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}

-(Boolean)leftExitRight {
    Boolean ret;
    switch (self.kind) {
        case cross:
        case left_right:
        case y_inv_left:
        case water_both:
        case water_right:
        case y_right:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}

-(Boolean)leftExitLeft {
    Boolean ret;
    switch (self.kind) {
        case cross:
        case through:
        case water_both:
        case water_left:
        case y_inv_left:
        case y_left:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}

-(Boolean)rightExitLeft {
    Boolean ret;
    switch (self.kind) {
        case cross:
        case right_left:
        case y_inv_right:
        case water_both:
        case water_left:
        case y_left:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}

-(Boolean)RightExitRight {
    Boolean ret;
    switch (self.kind) {
        case cross:
        case through:
        case y_inv_right:
        case water_both:
        case water_right:
        case y_right:
            ret = true;
            break;
        default:
            ret = false;
    }
    return ret;
}

-(NSString *)imageName {
    /*     none,
    cross,
    through,
    left_right,
    right_left,
    y_inv_left,
    y_inv_right,
    y_left,
    y_right */

    NSString *ret;
    switch (self.kind) {
        case none:
            ret = @"none.png"; break;
        case cross:
            ret = @"cross.png"; break;
        case through:
            ret = @"through.png"; break;
        case left_right:
            ret = @"left_right.png"; break;
        case right_left:
            ret = @"right_left.png"; break;
        case y_inv_left:
            ret = @"y_inv_left.png"; break;
        case y_inv_right:
            ret = @"y_inv_right.png"; break;
        case y_left:
            ret = @"y_left.png"; break;
        case y_right:
            ret = @"y_right.png"; break;
        case water_both:
            ret = @"water_both.png"; break;
        case water_right:
            ret = @"water_right.png"; break;
        case water_left:
            ret = @"water_left.png"; break;
        case fire:
            ret = @"fire.png"; break;
        case hider_all:
            ret = @"hider_all.png"; break;
        case hider_left:
            ret = @"hider_left.png"; break;
        case hider_right:
            ret = @"hider_right.png"; break;
        default:
            ret = nil;
            break;
    }
    return ret;
}

- (void)refreshImage
{
    self.image = [UIImage imageNamed:[self imageName]];
}

- (Boolean)chooseInputRight;
{
    if (self.kind == none) {
        int rnd = rand() % 6;
        self.kind = none + 1;
        while(rnd > 0) {
            self.kind ++;
            if([self canInputRight]){
                rnd --;
            }
        }
    }
    return [self canInputRight];
    
}
- (Boolean)chooseInputLeft;
{
    if (self.kind == none) {
        int rnd = rand() % 6;
        self.kind = none + 1;
        while(rnd > 0) {
            self.kind ++;
            if([self canInputLeft]){
                rnd --;
            }
        }
    }
    return [self canInputLeft];
}

@end
