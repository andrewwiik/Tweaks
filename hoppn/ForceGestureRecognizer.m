@implementation UITouch (Private)



@end













@implementation ForceGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action{

    if ((self = [super initWithTarget:target action:action])){

	// so simple there's no setup

    }

    return self;

}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

	[super touchesBegan:touches withEvent:event];

    UITouch *touch = [touches anyObject];

    Radius = [touch getRadius];

	X = [touch getX];

	Y = [touch getY];

	Density = [touch getDensity];

	Quality = [touch getQuality];

	//touchPoint = CGPointMake( X, Y);

	/* if ([touch _pathMajorRadius] > 40) {

		self.state = UIGestureRecognizerStateBegan;

		MenuOpen = YES;

	} */

	if (hasIncreasedByPercent(kHomeScreenForceSensitivity, Density, lastDensity) && hasIncreasedByPercent(kHomeScreenForceSensitivity, Radius, lastRadius)) {

		self.state = UIGestureRecognizerStateBegan;

    //self.cancelsTouchesInView = YES;

		NSLog(@"Begin Complete");

		MenuOpen = YES;

	}

	if ([touch _pathMajorRadius] > kPeekPopForceSensitivity) {

		self.state = UIGestureRecognizerStateBegan;

    //self.cancelsTouchesInView = YES;

		NSLog(@"Begin Complete");

		MenuOpen = YES;

	}

	lastRadius = Radius;

	lastX = X;

	lastY = Y;

	lastDensity = Density;

	lastQuality = Quality;

}



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

	[super touchesMoved:touches withEvent:event];

	UITouch *touch = [touches anyObject];

  Radius = [touch getRadius];

	X = [touch getX];

	Y = [touch getY];

	Density = [touch getDensity];

	Quality = [touch getQuality];

	//touchPoint = CGPointMake( X, Y);

	if (MenuOpen == NO) {

		if ((lastX - [touch getX] >= 10 || lastX - [touch getX] <= -10) || (lastY - [touch getY] >= 10 || lastY - [touch getY] <= -10)) {

			self.state = UIGestureRecognizerStateFailed;

			NSLog(@"Too Much Movement");

	}

    if ([touch _pathMajorRadius] > kPeekPopForceSensitivity) {

      self.state = UIGestureRecognizerStateBegan;

      //self.cancelsTouchesInView = YES;

      NSLog(@"Begin Complete");

      MenuOpen = YES;

    }

	}

	if (self.state == UIGestureRecognizerStatePossible) { 

		if (hasIncreasedByPercent(kHomeScreenForceSensitivity, Density, lastDensity) && hasIncreasedByPercent(kHomeScreenForceSensitivity, Radius, lastRadius)) {

			self.state = UIGestureRecognizerStateBegan;

      // self.cancelsTouchesInView = YES;

			MenuOpen = YES;

		}

    if ([touch _pathMajorRadius] > kPeekPopForceSensitivity) {

      self.state = UIGestureRecognizerStateBegan;

      //self.cancelsTouchesInView = YES;

      NSLog(@"Begin Complete");

      MenuOpen = YES;

    }

	}

	if (self.state == UIGestureRecognizerStateChanged) {

		if (hasIncreasedByPercent(kHomeScreenForceSensitivity, Density, lastDensity) && hasIncreasedByPercent(kHomeScreenForceSensitivity, Radius, lastRadius)) {

			touchPoint = CGPointMake( X, Y);

			// self.state = UIGestureRecognizerStateEnded;

		}

		else {

			self.state = UIGestureRecognizerStateChanged;

      //self.state = UIGestureRecognizerStateEnded;

		}

	}

	lastRadius = Radius;

	lastX = X;

	lastY = Y;

	lastDensity = Density;

	lastQuality = Quality;

	touchPoint = CGPointMake( X, Y);

}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

	[super touchesEnded:touches withEvent:event];

    self.state = UIGestureRecognizerStateEnded;

    MenuOpen = NO;

}



-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

	[super touchesCancelled:touches withEvent:event];

    self.state = UIGestureRecognizerStateCancelled;

}



-(void)reset{

	[super reset];

    lastRadius = 0;

  lastX = 0;

  lastY = 0;

  lastDensity = 0;

  lastQuality = 0;

  touchPoint = CGPointMake( 0, 0);

}

@end