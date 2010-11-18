//
//  TrailerView.m
//  Trailers
//

#import "TrailerView.h"
#import "Trailer.h"
#import "TrailersViewController.h"

@implementation TrailerView

@synthesize trailer, trailersViewController;

static UIImage *cover = nil;

+ (TrailerView*)viewWithTrailer:(Trailer*)trailer;
{
    return [[[[self class] alloc] initWithTrailer:trailer] autorelease];
}
-(id)initWithTrailer:(Trailer*)aTrailer;
{
    CGRect frame = CGRectMake(0, 0, 150, 120);
    
    if ((self = [super initWithFrame:frame]))
    {
        cover = [[UIImage imageNamed:@"TrailerCover.png"] retain];

        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    
    image = [[UIImage imageNamed:@"TrailerNoArt.png"] retain];
    self.trailer = aTrailer;

    [self startImage];
    return self;
}

- (void)drawRect:(CGRect)rect {
	if( image == NULL ){
		[[UIImage imageNamed:@"TrailerNoArt.png"] drawInRect:CGRectMake(4, 3, 134, 75)];
	}else{
		[image drawInRect:CGRectMake(4, 3, 134, 75)];
	}
	[cover drawInRect:CGRectMake(0, 0, 142, 82)];
	
	[[UIColor blackColor] set];
    NSLog(@"%@",self.trailer.title);
	[self.trailer.title drawInRect:CGRectMake(0, 77, self.frame.size.width, 12)
                    withFont:[UIFont boldSystemFontOfSize:12]
               lineBreakMode:UILineBreakModeTailTruncation
                   alignment:UITextAlignmentCenter];
	[self.trailer.duration drawInRect:CGRectMake(0, 91, self.frame.size.width, 12)
                            withFont:[UIFont systemFontOfSize:12]
                       lineBreakMode:UILineBreakModeTailTruncation
                           alignment:UITextAlignmentCenter];
	[[UIColor whiteColor] set];
	[self.trailer.title drawInRect:CGRectMake(0, 78, self.frame.size.width, 12)
                          withFont:[UIFont boldSystemFontOfSize:12]
                     lineBreakMode:UILineBreakModeTailTruncation
                         alignment:UITextAlignmentCenter];
	[self.trailer.duration drawInRect:CGRectMake(0, 92, self.frame.size.width, 12)
                             withFont:[UIFont systemFontOfSize:12]
                        lineBreakMode:UILineBreakModeTailTruncation
                            alignment:UITextAlignmentCenter];
}
- (void)rotate{
	[pop dismissPopoverAnimated:NO];
}

- (void)startImage{
    imageConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.trailer.imageURL] delegate:self];
    [imageConnection start];
    imageData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == imageConnection ){
        [imageData appendData:data];
    }
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {	
    if (connection == imageConnection){
        image = [[UIImage imageWithData:imageData] retain];
        [imageData release];
        [self setNeedsDisplay];
    }
}

#pragma mark interaction
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
		
		CGRect popoverFrame = CGRectMake(0, 0, self.frame.size.width, [self.trailer.versions count]*44);
		UITableView *tableView = [[UITableView alloc] initWithFrame:popoverFrame style:UITableViewStylePlain];
		tableView.scrollEnabled = NO;
		tableView.delegate = self;
		tableView.dataSource = self;
		
		UIViewController *controller = [[UIViewController alloc] init];
		controller.view.frame = popoverFrame;
		controller.contentSizeForViewInPopover = popoverFrame.size;
		[controller.view addSubview:tableView];
		
		pop = [[UIPopoverController alloc] initWithContentViewController:controller];
		[pop presentPopoverFromRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) inView:self permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
	}else{
		NSString *link = [[self.trailer.versions objectAtIndex:0] objectForKey:@"link"];
		link = [link stringByReplacingOccurrencesOfString:@"480p" withString:@"r320i"];
		link = [link stringByReplacingOccurrencesOfString:@"720p" withString:@"r320i"];
		link = [link stringByReplacingOccurrencesOfString:@"1080p" withString:@"r320i"];
		[trailersViewController playMovie:[NSURL URLWithString:link]];
	}
	
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.trailer.versions count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"resolutionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.textLabel.text = [[self.trailer.versions objectAtIndex:indexPath.row] objectForKey:@"resolution"];
	cell.detailTextLabel.text = [[self.trailer.versions objectAtIndex:indexPath.row] objectForKey:@"size"];
	
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[trailersViewController playMovie:[NSURL URLWithString:[[self.trailer.versions objectAtIndex:indexPath.row] objectForKey:@"link"]]];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[pop dismissPopoverAnimated:YES];
}


- (void)dealloc {
    
    [trailer release];
    [image release];
    [imageData release];
    [imageConnection release];
    [pop release];
    [trailersViewController release];
    [super dealloc];
}


@end
