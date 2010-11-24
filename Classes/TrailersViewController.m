//
//  TrailersViewController.m
//  Trailers
//

#import "TrailersViewController.h"
#import "Movie.h"
#import "MovieView.h"
#import "MenuController.h"

@implementation TrailersViewController

- (void)viewDidLoad;
{
	self.title = @"Trailers";
	
	scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	scrollView.clipsToBounds = NO;
	[self.view addSubview:scrollView];
	
	shading = [[UIView alloc] initWithFrame:scrollView.frame];
	shading.alpha = 0;
	shading.backgroundColor = [UIColor blackColor];
	[scrollView addSubview:shading];
    
    menu = [[MenuController alloc] init];
	menu.trailersViewController = self;
	menu.view.frame = CGRectMake(0, 0, scrollView.frame.size.width, 60);
	[scrollView	addSubview:menu.view];

    orientation = [UIApplication sharedApplication].statusBarOrientation;
}

- (void)viewWillAppear:(BOOL)animated{
    
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
		[self.navigationController setNavigationBarHidden:YES animated:YES];
	}
    
	if( [movies count] ){
		[self layoutMoviesWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
	}
    
	
	if( orientation != [UIApplication sharedApplication].statusBarOrientation ){
		orientation = [UIApplication sharedApplication].statusBarOrientation;
		
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
			[[UIApplication sharedApplication] setStatusBarHidden:YES];
		}
		
	}
	
}
- (void)viewDidAppear:(BOOL)animated{
	if( [movies count] == 0 ){
        [self updateMovies:[Movie moviesWithMode:MovieModeRecent]]; 
	}
	[[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	[self stopMovie];
}

- (void)loadMoviesRecent{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];

    [self loadMoviesWithMode:MovieModeRecent];
    
    [pool release];
}
- (void)loadMoviesPopular{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    [self loadMoviesWithMode:MovieModePopular];
    
    [pool release];
}

- (void)loadMoviesWithMode:(MovieMode)mode;
{
    [self clearMovies];
    
    [self performSelectorOnMainThread:@selector(updateMovies:) withObject:[Movie moviesWithMode:mode] waitUntilDone:NO];
}
- (void)loadMoviesWithTerm:(NSString*)term;
{
    NSAutoreleasePool *pool;
    pool = [[NSAutoreleasePool alloc] init];
    
    [self loadMoviesWithSearchTerm:term];
    
    [pool release];
}
- (void)loadMoviesWithSearchTerm:(NSString*)term;
{
    
    [self clearMovies];

    [self performSelectorOnMainThread:@selector(updateMovies:) withObject:[Movie moviesWithTerm:term] waitUntilDone:NO];

}
//- (void)showMovieWithURL:(NSURL*)url;
//{
//	[UIView setAnimationsEnabled:NO];
//	Movie *m = [Movie movieWithURL:[NSURL URLWithString:[[url absoluteString] stringByReplacingOccurrencesOfString:@"trailers://" withString:@"http://"]]];
//	urlMovie = [MovieView viewWithMovie:m];
//	urlMovie.trailersViewController = self;
//	urlMovie.tag = 0;
//	[scrollView addSubview:urlMovie];
//	[urlMovie touchesEnded:NULL withEvent:NULL];
//	
//	[UIView setAnimationsEnabled:YES];
//
//}
- (void)clearMovies;
{
    [UIView beginAnimations:NULL context:nil];
	[UIView setAnimationDuration:0.2];
	for(MovieView *view in movies){
        for(MovieView *view in movies){
            view.alpha = 0;
            view.frame = CGRectMake(view.center.x, view.center.y, 0, 0);
        }
	}
	[UIView commitAnimations];

}
- (void)updateMovies:(NSArray*)a;
{    

    NSMutableArray *newMovies = [[NSMutableArray alloc] init];
    for(Movie *amovie in a){
        amovie.view = [MovieView viewWithMovie:amovie];
        [newMovies addObject:amovie.view];
    }
    [movies release];
    movies = newMovies;
    
    MovieView *view;
    for(int i=0;i<[movies count];i++){
        view = [movies objectAtIndex:i];
        
        view.trailersViewController = self;
		view.alpha = 0;
		view.tag = i;
		view.exclusiveTouch = YES;
		
		[scrollView addSubview:view];
		[view release];
	}

    [self layoutMoviesWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    [UIView beginAnimations:NULL context:nil];
	[UIView setAnimationDuration:0.5];
	for(MovieView *view in movies){
        view.alpha = 1;
	}
	[UIView commitAnimations];

}
- (void)layoutMoviesWithInterfaceOrientation:(UIInterfaceOrientation)anOrientation;
{
    [self layoutWithInterfaceOrientation:anOrientation];
    
    int numColumns = scrollView.bounds.size.width/140;
	float margins = (scrollView.bounds.size.width - numColumns*140.0);
	margins /= numColumns*2.0;
	
	float x,y,maxY;
	for(MovieView *view in movies){

        x = (view.tag%numColumns)*140 + (view.tag%numColumns)*margins*2.0 + margins;
        y = (view.tag/numColumns)*235 + (view.tag/numColumns)*10.0 + 20 + menu.view.frame.size.height;
			
        if ( self.view.frame.size.height < 700 ){
            y -= (view.tag/numColumns)*15 + 15;
        }
			
			
        if(y>maxY) maxY = y;
        
        if( view.frame.size.width > 140 ){
            [view layoutInSuperView];
            [view layoutDetailView];
            [view setInitialRect:CGRectMake((int)x,(int)y,140,235)];
        }else{
            view.frame = CGRectMake((int)x,(int)y,140,235);
        }
	}
	maxY += 245;
	
	if ( self.view.frame.size.height < 700 ){
		y -= 15;
	}	
	
	if(maxY < scrollView.frame.size.height){
		maxY = scrollView.frame.size.height;
	}
	[scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width,maxY)];
	
	CGRect frame = shading.bounds;
	frame.size = scrollView.contentSize;
	shading.frame = frame;

}


- (void)detailViewStarting;
{
	scrollView.scrollEnabled = NO;
    
	[scrollView bringSubviewToFront:shading];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	shading.alpha = 0.7;
	[UIView commitAnimations];
}
- (void)detailViewEnding;
{
	scrollView.scrollEnabled = YES;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	shading.alpha = 0;
	[UIView commitAnimations];
}


- (void)playMovie:(NSURL*)url{
	if ([url scheme]){
		movie = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
		movie.moviePlayer.shouldAutoplay = YES;
		movie.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
		
		[self presentMoviePlayerViewControllerAnimated:movie];
	}
}
- (void)stopMovie{
	if( movie != NULL ){
        
		[movie.moviePlayer pause];
		[movie release];
		movie = NULL;
	}
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)layoutWithInterfaceOrientation:(UIInterfaceOrientation)anOrientation{
	
	
	float scrollPos = scrollView.contentOffset.y*scrollView.frame.size.width/scrollView.frame.size.height;
	
	CGRect frame = scrollView.frame;
	if(anOrientation==UIDeviceOrientationLandscapeLeft || anOrientation==UIDeviceOrientationLandscapeRight){
		frame.size.width = [[UIScreen mainScreen] applicationFrame].size.height;
		frame.size.height = [[UIScreen mainScreen] applicationFrame].size.width;
	}else{
		frame.size.width = [[UIScreen mainScreen] applicationFrame].size.width;
		frame.size.height = [[UIScreen mainScreen] applicationFrame].size.height;
	}
	scrollView.frame = frame;
	
	CGRect menuFrame = menu.view.frame;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && anOrientation==(UIDeviceOrientationPortrait||UIDeviceOrientationPortraitUpsideDown) ){
		menuFrame.size.height = 100;
	}else{
		menuFrame.size.height = 60;
	}	
	menuFrame.size.width = scrollView.frame.size.width;
	menu.view.frame = menuFrame;
	
	
	if( scrollView.contentSize.height < (frame.size.height + menu.view.frame.size.height) ){
		[scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height + menu.view.frame.size.height)];
	}
	
	
	
	
	scrollPos *= scrollView.frame.size.height/scrollView.frame.size.width;
    
	if(scrollPos <= 170 ){
		scrollPos = menu.view.frame.size.height - 1;
	}
    
	[scrollView setContentOffset:CGPointMake(0,scrollPos) animated:NO];
	
    /*
	float errorOffset = 0;
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
		errorImage.frame = CGRectMake(0, 0, 200, 200);
		errorOffset = -20;
	}else{
		errorImage.frame = CGRectMake(0, 0, 280, 280);
	}
	errorImage.center = scrollView.center;
	errorImage.frame = CGRectMake(errorImage.frame.origin.x, errorImage.frame.origin.y + errorOffset,
								  errorImage.frame.size.width, errorImage.frame.size.height);
	errorMessage.contentMode = UIViewContentModeTop;
	errorMessage.frame = CGRectMake(0,
									errorImage.frame.origin.y + errorImage.frame.size.height + errorOffset,
									scrollView.frame.size.width,
									80);
     */
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration{
    orientation = [UIApplication sharedApplication].statusBarOrientation;
    if( [movies count] ){
		[self layoutMoviesWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
	}else{
		[self layoutWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [scrollView release];
    [shading release];
    [menu release];
    
    scrollView = nil;
    shading = nil;
    menu = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [movies release];
    [movie release];
    [super dealloc];
}


@end
