    //
//  MenuController.m
//  Trailers
//

#import "MenuController.h"
#import "TrailersViewController.h"

@implementation MenuController

@synthesize trailersViewController;
@synthesize search, recentButton, popularButton/*, boxOfficeButton, soonButton*/;



- (void)viewDidLoad{

	menuLeft = [UIImage imageNamed:@"MenuLeft.png"];
	menuRight = [UIImage imageNamed:@"MenuRight.png"];
	menuCenter = [UIImage imageNamed:@"MenuCenter.png"];
	menuLeftHighlighted = [UIImage imageNamed:@"MenuLeftHighlighted.png"];
	menuRightHighlighted = [UIImage imageNamed:@"MenuRightHighlighted.png"];
	menuCenterHighlighted = [UIImage imageNamed:@"MenuCenterHighlighted.png"];
	menuLeftSelected = [UIImage imageNamed:@"MenuLeftSelected.png"];
	menuRightSelected = [UIImage imageNamed:@"MenuRightSelected.png"];
	menuCenterSelected = [UIImage imageNamed:@"MenuCenterSelected.png"];
	
	[self.recentButton setSelected:YES];
	[self.recentButton setBackgroundImage:menuLeft forState:UIControlStateNormal];
	[self.popularButton setBackgroundImage:menuRight forState:UIControlStateNormal];
	[self.recentButton setBackgroundImage:menuLeftSelected forState:UIControlStateSelected];
	[self.popularButton setBackgroundImage:menuRightSelected forState:UIControlStateSelected];
	[self.recentButton setBackgroundImage:menuLeftHighlighted forState:UIControlStateHighlighted];
	[self.popularButton setBackgroundImage:menuRightHighlighted forState:UIControlStateHighlighted];
}


- (IBAction)click:(id)sender{
    [trailersViewController clearMovies];
	if(sender==self.recentButton){
		[self.recentButton setSelected:YES];
		[self.popularButton setSelected:NO];
		[trailersViewController performSelectorInBackground:@selector(loadMoviesRecent) withObject:nil];
	}else if(sender==self.popularButton){
		[self.recentButton setSelected:NO];
		[self.popularButton setSelected:YES];
		
		[trailersViewController performSelectorInBackground:@selector(loadMoviesPopular) withObject:nil];
	}	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [trailersViewController clearMovies];
	[self.recentButton setSelected:NO];
	[self.popularButton setSelected:NO];
    [trailersViewController performSelectorInBackground:@selector(loadMoviesWithTerm:) withObject:textField.text];
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [recentButton release];
    [popularButton release];
    [search release];
    recentButton = nil;
    popularButton = nil;
    search = nil;
}


- (void)dealloc {
    
    [menuLeft release];
    [menuLeftHighlighted release];
    [menuLeftSelected release];
    [menuRight release];
    [menuRightHighlighted release];
    [menuRightSelected release];
    [menuCenter release];
    [menuCenterHighlighted release];
    [menuCenterSelected release];
    
    [super dealloc];

}


@end
