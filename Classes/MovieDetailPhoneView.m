//
//  MovieDetailPhoneView.m
//  Trailers
//
//  Created by Lucas Harding on 10-04-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MovieDetailPhoneView.h"
#import "MovieView.h"
@class TrailersViewController;

@implementation MovieDetailPhoneView

@synthesize movieView,infoSeperator;
@synthesize poster,releaseDateLabel,genreLabel,directorLabel,castLabel,descriptionLabel,descriptionSeperator,loadingView,trailers;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"MovieDetailBGTile.png"]];
		self.descriptionLabel.text = @"";
	}
	self.castLabel.font = [UIFont systemFontOfSize:12];
	self.descriptionLabel.font = [UIFont systemFontOfSize:12];
	self.view.clipsToBounds = YES;
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self layoutSubviews];
}
- (void)viewDidAppear:(BOOL)animated{
	//[(TrailersViewController*)self.movieView.trailersViewController stopMovie];
}

#pragma mark layout
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[self layoutSubviews];
}
- (void)layoutSubviews{
	CGRect frame;
	
	frame = self.castLabel.frame;
	frame.size.height = [self.castLabel.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(frame.size.width-20,1000) lineBreakMode:UILineBreakModeWordWrap].height;
	if(frame.size.height==0){
		frame.size.height += 40;
	}else{
		frame.size.height += 10;
	}
	self.castLabel.frame = frame;
	self.castLabel.scrollEnabled = NO;
	
	frame = self.infoSeperator.frame;
	frame.origin.y = self.castLabel.frame.origin.y + self.castLabel.frame.size.height;
	
	if( frame.origin.y >= (self.poster.frame.origin.y + self.poster.frame.size.height + 5) ){
		self.infoSeperator.frame = frame;
	}
	
	
	frame = self.descriptionLabel.frame;
	frame.origin.y = self.infoSeperator.frame.origin.y + 2;
	frame.size.height = self.descriptionSeperator.frame.origin.y - frame.origin.y;
	self.descriptionLabel.frame = frame;
	self.descriptionSeperator.hidden = NO;
	
	
	if( [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight ){
		self.descriptionLabel.hidden = YES;
		self.infoSeperator.hidden = YES;
	}else{
		self.descriptionLabel.hidden = NO;
		self.infoSeperator.hidden = NO;
	}
	
}


#pragma mark api
- (void)addTrailer:(UIView*)v{
	[self.trailers addView:v];
}
- (void)clearTrailers{
    [self.trailers empty];
}
- (void)startAnimating{
	[self.loadingView startAnimating];
}
- (void)stopAnimating{
	[self.loadingView stopAnimating];
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
	
	self.releaseDateLabel.text = [s stringByReplacingOccurrencesOfString:@"In theatres: " withString:@""];
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

#pragma mark boring
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [poster release];
    [releaseDateLabel release];
    [genreLabel release];
    [directorLabel release];
    [castLabel release];
    [descriptionLabel release];
    [descriptionSeperator release];
    [infoSeperator release];
    [loadingView release];
    [trailers release];
    [super viewDidUnload];
}


- (void)dealloc {
    [movieView release];
    [super dealloc];
}


@end
