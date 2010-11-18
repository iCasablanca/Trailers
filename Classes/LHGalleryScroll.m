//
//  LHGalleryScroll.m
//  LHGalleryScroll
//
//  Created by Lucas Harding on 10-03-28.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "LHGalleryScroll.h"


@implementation LHGalleryScroll

-(void)setUp{
	views = [[NSMutableArray alloc] init];
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, (int)self.frame.size.width, (int)self.frame.size.height)];
	[self addSubview:scrollView];
	
//	self.backgroundColor = [UIColor redColor];
//	scrollView.backgroundColor = [UIColor greenColor];
}
- (void)empty{
    for(UIView *view in views){
        NSLog(@"remove %@ from superview",view);
        [view removeFromSuperview];
    }
    [views release];
	views = [[NSMutableArray alloc] init];
}
-(void)addView:(UIView*)view{
	if(views==NULL) [self setUp];

	[view retain];
	[views addObject:view];
	
	
	[self arrange];
}
-(void)layoutSubviews{
	scrollView.frame = CGRectMake(0, 0, (int)self.frame.size.width, (int)self.frame.size.height);
	[self arrange];
}
-(NSArray*)views{
	return [NSArray arrayWithArray:views];
}
- (void)arrange{
	float margin = 2;
	float x,y,width,height;
	for(UIView *view in views){
		x += margin;
		
		height = view.frame.size.height;
		width = view.frame.size.width;
		
		y = 0;
		
		view.frame = CGRectMake((int)x, (int)y, width, height);
        NSLog(@"%@",view.superview);
		if( view.superview == NULL )
            [scrollView addSubview:view];
		
		x += width + margin;
	}
	[scrollView setContentSize:CGSizeMake(x, scrollView.frame.size.height)];
}


- (void)dealloc {
    
    [scrollView release];
    [views release];
    [super dealloc];

}


@end
