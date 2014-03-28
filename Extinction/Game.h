//
//  Game.h
//  ToDoList
//
//  Created by Frédéric Leroy on 06/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCell.h"
#import "GameRow.h"

enum GAME_DIFFICULTY {
    easy,
    medium,
    hard
    };

@interface Game : NSObject

@property   enum GAME_DIFFICULTY difficulty;
@property   NSInteger nbRows;
@property   NSInteger nbCols;
@property   NSInteger width;
@property   NSInteger height;
@property   NSMutableArray *solution;
@property   GameRow *startRow;
@property   NSInteger nbStarts;
@property   NSInteger nbFires;
@property   CGFloat   noiseRatio;
@property   NSInteger nbSecondsToSolve;

- (id)init:(enum GAME_DIFFICULTY)difficulty;
- (GameCell *)cellAt:(NSInteger)row andCol:(NSInteger)col;
- (GameRow *)rowAt:(NSInteger)row;
- (Boolean)isSolved;

@end
