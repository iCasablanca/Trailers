//
//  LHGalleryScroll.h
//  LHGalleryScroll
//
//  Created by Lucas Harding on 10-03-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//


@interface LHGalleryScroll : UIScrollView {
	UIScrollView *scrollView;
	NSMutableArray *views;
}


- (void)setUp;
- (void)addView:(UIView *)view;
- (void)arrange;
- (NSArray*)views;
- (void)empty;
@end
