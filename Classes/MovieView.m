//
//  MovieView.m
//  Trailers
//

#import "MovieView.h"
#import "Movie.h"
#import "TrailersViewController.h"
#import "MovieDetailView.h"
#import "MovieDetailPhoneView.h"
#import "Trailer.h"
#import "TrailerView.h"

@implementation MovieView

@synthesize movie, detailView, trailersViewController;

static UIColor *background = nil;
static UIImage *cover = nil;
static UIImage *coverHighlighted = nil;

+ (MovieView*)viewWithMovie:(Movie*)movie;
{
    return [[[[self class] alloc] initWithMovie:movie] autorelease];
}
-(id)initWithMovie:(Movie*)aMovie;
{
    CGRect frame = CGRectMake(0, 0, 140, 235);
    
    if ((self = [super initWithFrame:frame]))
    {
        //background = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]] retain];
        background = [[UIColor redColor] retain];
		cover = [[UIImage imageNamed:@"MovieCover.png"] retain];
		coverHighlighted = [[UIImage imageNamed:@"MovieCoverHighlighted.png"] retain];
		
		self.opaque = NO;
		self.clipsToBounds = NO;
    }
        
    self.movie = aMovie;
    self.frame = frame;
    expanded = NO;
    [self startPoster];
    return self;
} 

- (void)startPoster{
	posterPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[[self.movie.movieURL relativeString] stringByReplacingOccurrencesOfString:@"/" withString:@"_"]]] retain];
	
	if( ![[NSFileManager defaultManager] fileExistsAtPath:posterPath] ){
        NSLog(@"starting %@",self.movie.imageURL);
		posterConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.movie.imageURL] delegate:self];
		[posterConnection start];
		posterData = [[NSMutableData alloc] init];
	}else{
		posterData = [NSData dataWithContentsOfFile:posterPath];
		[posterData retain];
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == posterConnection ){
        [posterData appendData:data];
    }
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {	
    if (connection == posterConnection){
        [UIImageJPEGRepresentation([UIImage imageWithData:posterData], 100) writeToFile:posterPath atomically: YES];
        [posterData retain];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
	if(!expanded){
		[[UIImage imageWithData:posterData] drawInRect:CGRectMake(5, 4, 130, 188)];
		
		if(!highlighted){
			[cover drawAtPoint:CGPointMake(1, 0)];
		}else{
			[coverHighlighted drawAtPoint:CGPointMake(1, 0)];
		}
		
		
		[[UIColor blackColor] set];
		[self.movie.title drawInRect:CGRectMake(5.0, 199.0, self.frame.size.width-5.0*2.0, self.frame.size.height-200.0)
				 withFont:[UIFont boldSystemFontOfSize:11]
			lineBreakMode:UILineBreakModeWordWrap
				alignment:UITextAlignmentCenter];
		
		[[UIColor whiteColor] set];
		[self.movie.title drawInRect:CGRectMake(5.0, 200.0, self.frame.size.width-5.0*2.0, self.frame.size.height-200.0)
				 withFont:[UIFont boldSystemFontOfSize:11]
			lineBreakMode:UILineBreakModeWordWrap
				alignment:UITextAlignmentCenter];
	}
}
-(void)setInitialRect:(CGRect)rect{
	initialRect = rect;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	highlighted = YES;
	[self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	highlighted = NO;
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	highlighted = NO;
    [self setNeedsDisplay];

	if( detailView == NULL ){
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
			detailView = [[MovieDetailView alloc] initWithNibName:@"MovieDetailView" bundle:nil];
		}else{
			detailView = [[MovieDetailPhoneView alloc] initWithNibName:@"MovieDetailPhoneView" bundle:nil];
		}

		detailView.movieView = self;
        [self.movie loadMoreInfo];
	}
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
		
		expanded = !expanded;
		
		if(expanded){
			[trailersViewController detailViewStarting];
			initialRect = self.frame;
			[self setUpDetailView];
			[[self superview] bringSubviewToFront:self];
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(flipDidStop)];
		self.userInteractionEnabled = NO;
		if(expanded){
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
								   forView:self
									 cache:YES];
			[self layoutInSuperView];
			[self layoutDetailView];
			[self addSubview:detailView.view];
		}else{
			[trailersViewController detailViewEnding];
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
								   forView:self
									 cache:YES];
			
			self.frame = initialRect;
			[detailView.view removeFromSuperview];	
		}
		[UIView commitAnimations];
		[self setNeedsDisplay];
		
	}else{
		[self setUpDetailView];
		[self.trailersViewController.navigationController pushViewController:detailView animated:YES];
		[self setNeedsDisplay];
	}
}
- (void)flipDidStop;
{
    self.userInteractionEnabled = YES;
	
	if( !expanded ){
		[detailView release];
		detailView = NULL;
	}
}
- (void)setUpDetailView;
{
	[detailView setTitle:self.movie.title];
	
	
	NSString *releaseString;
	if( self.movie.releaseDate != NULL ){
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"EEE, LLLL d, yyyy"];
		releaseString = [NSString stringWithFormat:@"In theatres: %@",[df stringFromDate:self.movie.releaseDate]];
	}else{
		releaseString = [NSString stringWithString:@"In theatres: TBA"];
	}
	/*if(![rating isEqual:@"Not yet rated"]){
		releaseString = [releaseString stringByAppendingFormat:@" %@ Rated: %@",[NSString stringWithUTF8String:"•"],rating];
	}*/
	[detailView setReleaseDate:releaseString];
	[detailView setGenre:self.movie.genre];
	[detailView setDirector:self.movie.director];
    [detailView setCast:self.movie.cast];
	[detailView setPosterImage:[UIImage imageWithData:posterData]];
	[detailView setDescription:@""];
	[detailView layoutSubviews];
}
- (void)updateDetailDescription;
{
    [detailView setDescription:self.movie.description];
    [detailView stopAnimating];
    [detailView layoutSubviews];
}
- (void)updateDetailTrailers;
{    
    TrailerView *trailerView;
    for( Trailer *trailer in self.movie.trailers ){
        trailerView = [TrailerView viewWithTrailer:trailer];
        trailerView.trailersViewController = self.trailersViewController;
        [detailView addTrailer:trailerView];
    }
    [detailView stopAnimating];
    [detailView layoutSubviews];
}
- (void)layoutDetailView;
{
	if( detailView != NULL ){
		
		CGRect rect = detailView.view.frame;
		rect.size.height = (int)detailView.backgroundBottomImage.frame.origin.y + (int)detailView.backgroundBottomImage.frame.size.height;
		rect.origin.y = (int)(self.frame.size.height - rect.size.height) / 2;
		rect.origin.x = (int)(self.frame.size.width - rect.size.width) / 2;
		
		detailView.view.frame = rect;
		
	}
}

- (void)layoutInSuperView;
{
	UIScrollView *scrollView = (UIScrollView*)[self superview];
    
	CGRect frame = CGRectMake( 0, scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height);
	if( scrollView.contentOffset.y > scrollView.contentSize.height){
		frame.origin.y -= scrollView.contentOffset.y - scrollView.contentSize.height;
	}
	
	self.frame = frame;
}

- (void)dealloc {
    
    [movie release];
    [detailView release];
    [posterPath release];
    [posterData release];
    [posterConnection release];
    [trailersViewController release];

    [super dealloc];
}


@end
