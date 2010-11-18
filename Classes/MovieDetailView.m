    //
//  MovieDetailView.m
//  Trailers
//
//  Created by Lucas Harding on 10-03-25.
//  Copyright 2010 Apple Inc. All rights reserved.
//


#import "MovieDetailView.h"

#import "LHGalleryScroll.h"
#import "MovieView.h"
#import "TrailerView.h"

@implementation MovieDetailView

@synthesize movieView;
@synthesize infoSeperator,descriptionSeperator,backgroundTopImage,backgroundMiddleImage,backgroundBottomImage;
@synthesize poster,posterCover,titleLabel,releaseDateLabel,genreLabel,directorLabel,castLabel,descriptionLabel,loadingView,trailers;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.view.backgroundColor = [UIColor clearColor];
//		self.backgroundMiddleImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MovieDetailBGMiddle.png"]];
    }
	
	castLabel.font = [UIFont systemFontOfSize:12];
	descriptionLabel.font = [UIFont systemFontOfSize:12];

	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(rotate:) 
												 name:UIDeviceOrientationDidChangeNotification object:nil]; 
	
    return self;
}

#pragma mark interaction
- (IBAction)closeClicked{
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[movieView touchesEnded:NULL withEvent:NULL];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	return;
}


#pragma mark layout
- (void)layoutSubviews{
	CGRect frame;
	
	frame = self.castLabel.frame;
	frame.size.height = [self.castLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(frame.size.width-20,1000) lineBreakMode:UILineBreakModeWordWrap].height;
	if(frame.size.height==0){
		frame.size.height += 40;
	}else{
		frame.size.height += 24;
	}
	self.castLabel.frame = frame;
	self.castLabel.scrollEnabled = NO;
	
	frame = self.infoSeperator.frame;
	frame.origin.y = self.castLabel.frame.origin.y + self.castLabel.frame.size.height;
	self.infoSeperator.frame = frame;
		
	frame = self.descriptionLabel.frame;
	frame.size.width = 320;
	frame.origin.y = self.infoSeperator.frame.origin.y + 2;
	frame.size = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(frame.size.width,200) lineBreakMode:UILineBreakModeWordWrap];
	frame.size.height += 32;
	self.descriptionLabel.frame = frame;
	
	
	float minDescY = self.poster.frame.origin.y + self.poster.frame.size.height + 10;
	
	frame = self.descriptionSeperator.frame;
	frame.origin.y = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height;
	if( frame.origin.y < minDescY ) frame.origin.y = minDescY;
	self.descriptionSeperator.frame = frame;
	self.descriptionSeperator.hidden = NO;
		
	frame = self.trailers.frame;
	frame.origin.y = (int)self.descriptionSeperator.frame.origin.y + (int)self.descriptionSeperator.frame.size.height + 8;
	self.trailers.frame = frame;
	
	frame = self.backgroundMiddleImage.frame;
	frame.size.height = self.trailers.frame.origin.y + self.trailers.frame.size.height - self.backgroundMiddleImage.frame.origin.y - 85;
	self.backgroundMiddleImage.frame = frame;
	
	frame = self.backgroundBottomImage.frame;
	frame.origin.y = self.backgroundMiddleImage.frame.origin.y + self.backgroundMiddleImage.frame.size.height;
	self.backgroundBottomImage.frame = frame;


	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[self.movieView layoutDetailView];
	[UIView commitAnimations];
	
}
- (void)rotate:(NSNotification*)notification {
	for( TrailerView *trailerView in [self.trailers views] ){
		[trailerView rotate];
	}
}

#pragma mark api
- (void)addTrailer:(UIView*)v{
	[self.trailers addView:v];
}
- (void)clearTrailers{
    [self.trailers empty];
}
- (void)setTitle:(NSString*)s{
	self.titleLabel.text = s;
}
- (void)setDescription:(NSString*)s{
	self.descriptionLabel.text = s;
}
- (void)setGenre:(NSString*)s{
	self.genreLabel.text = s;
}
- (void)setDirector:(NSString*)s{
	self.directorLabel.text = s;
}
- (void)setReleaseDate:(NSString*)s{
	self.releaseDateLabel.text = s;
}
- (void)setCast:(NSString*)s{
	self.castLabel.text = s;
}
- (void)setPosterImage:(UIImage*)i{
	[self.poster setBackgroundImage:i forState:UIControlStateNormal];
}

- (NSString*)getDescription{return self.descriptionLabel.text;}
- (NSString*)getGenre{return self.genreLabel.text;}
- (NSString*)getDirector{return self.directorLabel.text;}
- (NSString*)getReleaseDate{return self.releaseDateLabel.text;}
- (NSString*)getCast{return self.castLabel.text;}


- (void)startAnimating{
	[self.loadingView startAnimating];
}
- (void)stopAnimating{
	[self.loadingView stopAnimating];
}




#pragma mark boring
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [poster release];
    [posterLarge release];
    [posterCover release];
    [titleLabel release];
    [releaseDateLabel release];
    [genreLabel release];
    [directorLabel release];
    [castLabel release];
    [descriptionLabel release];
    [descriptionSeperator release];
    [infoSeperator release];
    [backgroundTopImage release];
    [backgroundMiddleImage release];
    [backgroundBottomImage release];
    [loadingView release];
    [trailers release];
    [super viewDidUnload];
}


- (void)dealloc {
    [movieView release];
    [super dealloc];
}


@end
