//
//  EXTImageRowView.m
//  ToDoList
//
//  Created by Frédéric Leroy on 04/03/2014.
//  Copyright (c) 2014 Frédéric Leroy. All rights reserved.
//

#import "EXTImageRowView.h"

@interface EXTImageRowView ()

@property   CGFloat minVisibleX;
@property   CGFloat maxVisibleX;
@property   CGFloat minX;
@property   CGFloat maxX;
@property   GameRow *gameRow;
@property   Boolean draggingInProcess;

@end

@implementation EXTImageRowView

- (id)initWithFrame:(CGRect)frame andGameRow:(GameRow *)gameRow;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.nbCols = [gameRow.cells count];
        self.gameRow = gameRow;
        int index = 0;
        for(int t = 0; t < 3; t++) {
            for(int col = 0; col < [gameRow.cells count]; col++) {
                GameCell * cell = gameRow.cells[col];
                self.width = cell.width;
                self.height = cell.height;
                CGRect rect = CGRectMake(index * cell.width, 0, cell.width, cell.width);
                index ++;
                UIImage * image = [cell getImage];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                [imageView setImage:image];
                if(t != 1 && ! [gameRow canMove]) {
                    [imageView setHidden:YES];
                }
                [self addSubview:imageView];
            }
        }
        self.minX = frame.origin.x - 1 * self.nbCols * self.width;
        self.maxX = frame.origin.x + 1 * self.nbCols * self.width;
        self.minVisibleX = frame.origin.x + self.nbCols * self.width;
        self.maxVisibleX = self.minVisibleX + self.nbCols * self.width;
        // [self refreshOpacityOfImages];
    }
    return self;
}

- (id)initHiderWithFrame:(CGRect)frame andGameRow:(GameRow *)gameRow andInput:(enum CELL_INPUT)input andWidth:(NSInteger)width;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.nbCols = [gameRow.cells count];
        self.gameRow = gameRow;

        GameCell * cellFullHider = [[GameCell alloc] init];
        cellFullHider.kind = hider_all;
        GameCell * cellHider = [[GameCell alloc] init];
        if(input == left) {
            cellHider.kind = hider_left;
        } else {
            cellHider.kind = hider_right;
        }

        CGRect rect1 = CGRectMake(0, 0, width, width);
        CGRect rect2 = CGRectMake(width, 0, width, width);
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:rect1];
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:rect2];
        if(input == left) {
            [imageView1 setImage:[cellFullHider getImage]];
            [imageView2 setImage:[cellHider getImage]];
        } else {
            [imageView2 setImage:[cellFullHider getImage]];
            [imageView1 setImage:[cellHider getImage]];
        }
        [self addSubview:imageView1];
        [self addSubview:imageView2];
    }
    return self;
}

- (void)refreshOpacityOfImages;
{
    CGRect rect = [self frame];
    int nbSubViews =[self.subviews count];
    for(int i= 0; i < nbSubViews; i++) {
        UIImageView *subView = (UIImageView *)self.subviews[i];
        CGRect rectView = [subView frame];
        CGFloat low = rect.origin.x + rectView.origin.x + rectView.size.width;
        CGFloat high = rect.origin.x + rectView.origin.x;
        if(low <= self.minVisibleX - self.width - self.width / 2 || high >= self.maxVisibleX + self.width + self.width / 2) {
            [subView setHidden:YES];
        } else {
            [subView setHidden:NO];
            if([self.gameRow canMove]) {
                if(low >= self.minVisibleX + self.width / 2) {
                    if(high <= self.maxVisibleX - self.width / 2) {
                        [subView setAlpha:1];
                    } else {
                        if(self.draggingInProcess) {
                            [subView setAlpha:0.5];
                        } else {
                            [subView setAlpha:0];
                        }
                    }
                } else {
                    if(self.draggingInProcess) {
                        [subView setAlpha:0.5];
                    } else {
                        [subView setAlpha:0];
                    }
                }
                /*
                // we may compute an alpha
                if(low >= self.minVisibleX - self.width / 2 && low <= self.minVisibleX + self.width / 2) {
                    [subView setAlpha:1];
                } else if(high >= self.maxVisibleX - self.width / 2 && high <= self.maxVisibleX + self.width / 2) {
                    
                }
                }else if(high >= self.maxVisibleX - self.width / 2 && high <= self.maxVisibleX + self.width / 2) {
                    [subView setAlpha: (high - self.maxVisibleX) / self.width];
                } else {
                    [subView setAlpha:1];
                }
                 */
            } else {
                if(low <= self.minVisibleX || high >= self.maxVisibleX ) {
                    [subView setHidden:YES];
                } else {
                    [subView setHidden:NO];
                }
                
            }
        }
    }
    /*
    for(int i= 0; i < [self.subviews count]; i++) {
        UIImageView *subView = (UIImageView *)self.subviews[i];
        NSLog(@"subView %@ %d", subView, subView.hidden);
    }
     */
}
- (IBAction)panRow:(UIPanGestureRecognizer *)gestureRecognizer;
{
    EXTImageRowView *piece = (EXTImageRowView *)[gestureRecognizer view];
    
    CGRect rect = [piece frame];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.startX = rect.origin.x;
        self.currentX = self.startX;
        piece.draggingInProcess = true;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        piece.draggingInProcess = false;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged || [gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        self.currentX += translation.x;
        if(self.currentX < self.minX) {
            self.currentX = self.minX;
        } else if(self.currentX > self.maxX) {
            self.currentX = self.maxX;
        }
        
        CGFloat decal = 0;
        CGFloat delta_x = self.currentX - self.startX;
        if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
            CGFloat new_x = self.startX + round(delta_x / self.width) * self.width + decal;
            rect.origin.x = new_x;
            CGFloat currX = [piece frame].origin.x + self.nbCols * self.width;
            piece.gameRow.decalCellX = round((piece.minVisibleX - currX) / self.width);
            /*
            NSLog(@"Décalage de %d = %d", piece.gameRow.rowIndex, piece.gameRow.decalCellX);
            for(int col = 0; col< [piece.gameRow.cells count]; col++) {
                NSLog(@"Cell(%d,%d) = %@", piece.gameRow.rowIndex, col, [[piece.gameRow cellAt:col] imageName]);
            }
             */
        } else {
            rect.origin.x = self.currentX;
        }
        
        [piece setFrame:rect];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
