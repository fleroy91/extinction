//
//  Game.m
//  ToDoList
//
//  Created by Frédéric Leroy on 06/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import "Game.h"
@interface Game ()

@property NSInteger nbGenFires;

- (void)goDownFromCell:(GameCell *)cell row:(NSInteger)row col:(NSInteger)col from:(enum CELL_INPUT)input;
- (void)generateDownFromCell:(GameCell *)cell row:(NSInteger)row col:(NSInteger)col from:(enum CELL_INPUT)input;
- (void)changeCellToFire:(GameCell *) cell;
- (void)genSolution;
@end

@implementation Game

- (id)init:(enum GAME_DIFFICULTY)difficulty
{
    self = [super init];
    if (self) {
//        srand(time(0));
        self.difficulty = difficulty;
        switch (difficulty) {
            case easy:
                self.nbRows = 7;
                self.nbCols = 6;
                self.width = 44;
                self.height = 36;
                self.nbStarts = 2;
                self.nbFires = 2;
                self.noiseRatio = 30;
                self.nbSecondsToSolve = 90;
                break;
            case medium:
                self.nbRows = 9;
                self.nbCols = 7;
                self.width = 40;
                self.height = 32;
                self.nbStarts = 3;
                self.nbFires = 3;
                self.noiseRatio = 40;
                self.nbSecondsToSolve = 120;
                break;
            case hard:
                self.nbRows = 11;
                self.nbCols = 8;
                self.width = 32;
                self.height = 26;
                self.nbStarts = 4;
                self.nbFires = 4;
                self.noiseRatio = 50;
                self.nbSecondsToSolve = 150;
                break;
            default:
                break;
        }
        
        // First we generate an empty grid
        self.solution = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.nbRows; i ++) {
            GameRow * row = [[GameRow alloc] init];
            row.rowIndex = i;
            row.canMove = (i > 0 && i < self.nbRows - 1);
            for(int j = 0; j < self.nbCols; j++) {
                enum CELL_KIND cell_index = none;
                GameCell *cell = [[GameCell alloc] init:cell_index];
                cell.width = self.width;
                cell.height = self.height;
                cell.col = j;
                [row.cells addObject:cell];
            }
            [self.solution addObject:row];
        }
        self.nbGenFires = 0;
        do {
            [self genSolution];
        } while(self.nbGenFires < self.nbStarts);
        
        // We need to decal some rows
        for(int i = 1; i < self.nbRows - 1; i ++) {
            // To avoid 0
            int decalX = (rand() % (self.nbCols - 1)) + 1;
            GameRow * row = [self rowAt:i];
            [row applyDecalage:decalX];
        }
        
        // Then we add noise
        for(int i = 1; i < self.nbRows - 1; i ++) {
            GameRow * row = [self rowAt:i];
            for(int j = 0; j < self.nbCols; j++) {
                if(rand() * 100 < self.noiseRatio) {
                    [row changeCellForRandomKind:j];
                }
            }
        }
    }
    return self;
}

- (void)genSolution
{
    // We reset all
    for(int i = 0; i < self.nbStarts; i++) {
        for(int j = 0; j < self.nbCols; j++) {
            GameCell * cell = [self cellAt:i andCol:j];
            cell.kind = none;
        }
    }
    for(int i = 0; i < self.nbStarts; i++) {
        GameRow * row = [self rowAt:0];
        enum CELL_KIND cell_kind = water_both + (enum CELL_KIND)(rand() % [GameCell nbKindsForWater]);
        NSInteger col = [row changeKindForRandomCell:cell_kind];
        GameCell *cell = [self cellAt:0 andCol:col];
        [self generateDownFromCell:(GameCell *)cell row:0 col:col from:left];
    }
}

- (GameRow *)rowAt:(NSInteger)row {
    return self.solution[row];
}

- (GameCell *)cellAt:(NSInteger)row andCol:(NSInteger)col {
    GameRow *gameRow = self.solution[row];
    return [gameRow cellAt:col];
}

- (Boolean)isSolved
{
    // We first hide all cells
    for(int i = 0; i < self.nbRows; i ++) {
        GameRow * gameRow = [self rowAt:i];
        [gameRow hideCells];
    }
    
    // We search for the water and go down to the fires
    // It at the end there is still fires then it's not solved
    for(int i = 0; i < self.nbCols; i ++) {
        GameCell *cell = [self cellAt:0 andCol:i];
        if([cell isWater]) {
            [self goDownFromCell:cell row:0 col:i from:left];
        }
    }
    // We refresh the cells
    for(int i = 0; i < self.nbRows; i ++) {
        for(int j = 0; j < self.nbCols; j++) {
            GameCell *cell = [self cellAt:i andCol:j];
            if(cell.water_kind) {
                // cell.kind = cell.water_kind;
                [cell refreshImage];
                GameRow *gameRow = [self rowAt:i];
                [gameRow refreshCell:cell at:j];
            }
        }
    }
    Boolean is_solved = true;
    for(int i =0; i < self.nbCols; i++) {
        GameCell *cell = [self cellAt:(self.nbRows - 1) andCol:i];
        if([cell isFire] && cell.water_kind == none) {
            is_solved = false;
            break;
        }
    }
    for(int i = 0; i < self.nbRows; i ++) {
        GameRow * row = [self rowAt:i];
        [row.view setNeedsDisplay];
    }
    return is_solved;
}

- (void)generateDownFromCell:(GameCell *)cell row:(NSInteger)row col:(NSInteger)col from:(enum CELL_INPUT)input
{
    Boolean evenRow = (row % 2) == 0;
    Boolean canGoLeft = (! evenRow || col > 0) && (input == left ? [cell leftExitLeft] : [cell rightExitLeft]);
    Boolean canGoRight = (evenRow || col < self.nbCols - 1) && (input == left ? [cell leftExitRight] : [cell RightExitRight]);
    
    if(canGoLeft) {
        NSInteger colDown = (evenRow ? col - 1 : col);
        GameCell * subCell = [self cellAt:row + 1 andCol:colDown];
        if(row + 1 == self.nbRows -1) {
            [self changeCellToFire:subCell];
        } else if(subCell.kind == none) {
            if([subCell chooseInputRight]) {
                NSLog(@"Solution Cell(%ld,%ld) = %@", row+1, (long)colDown, [subCell imageName]);
                [self generateDownFromCell:subCell row:row+1 col:colDown from:right];
            }
        }
    }
    if(canGoRight) {
        NSInteger colDown = (evenRow ? col : col + 1);
        GameCell * subCell = [self cellAt:row + 1 andCol:colDown];
        if(row + 1 == self.nbRows -1) {
            [self changeCellToFire:subCell];
        } else if(subCell.kind == none) {
            if([subCell chooseInputLeft]) {
                NSLog(@"Solution Cell(%d,%d) = %@", row+1, colDown, [subCell imageName]);
                [self generateDownFromCell:subCell row:row + 1 col:colDown from:left];
            }
        }
    }
}

- (void)goDownFromCell:(GameCell *)cell row:(NSInteger)row col:(NSInteger)col from:(enum CELL_INPUT)input
{
    if(row == self.nbRows -1) {
        // We're down
        cell.water_kind = water_both;
    } else {
        Boolean evenRow = (row % 2) == 0;
        Boolean canGoLeft = (! evenRow || col > 0) && (input == left ? [cell leftExitLeft] : [cell rightExitLeft]);
        Boolean canGoRight = (evenRow || col < self.nbCols - 1) && (input == left ? [cell leftExitRight] : [cell RightExitRight]);
        
        if(canGoLeft) {
            NSInteger colDown = (evenRow ? col - 1 : col);
            GameCell * subCell = [self cellAt:row + 1 andCol:colDown];
            NSLog(@"Cell(%d,%d) = %@", row+1, colDown, [subCell imageName]);
            if([subCell canInputRight]) {
                [self goDownFromCell:subCell row:row + 1 col:colDown from:right];
            }
        }
        if(canGoRight) {
            NSInteger colDown = (evenRow ? col : col + 1);
            GameCell * subCell = [self cellAt:row + 1 andCol:colDown];
            NSLog(@"Cell(%d,%d) = %@", row+1, colDown, [subCell imageName]);
            if([subCell canInputLeft]) {
                [self goDownFromCell:subCell row:row + 1 col:colDown from:left];
            }
        }
        // What happens to the current cell
        if([cell canExitLeft] && [cell canExitRight]) {
            cell.water_kind = water_both;
        } else if([cell canExitRight]) {
            cell.water_kind = water_right;
        } else {
            cell.water_kind = water_left;
        }
    }
}


- (void)changeCellToFire:(GameCell *) cell;
{
    if(cell.kind != fire) {
        if(self.nbGenFires < self.nbFires) {
            cell.kind = fire;
            self.nbGenFires++;
        } else {
            cell.kind = none;
        }
    }
}
@end
