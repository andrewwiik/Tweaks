Import "M13ProgressViewRing.h" in your project.

Setup like this:

M13ProgressViewRing *ring = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
ring.showPercentage = NO; // Do you want to show the percentage in the middle?
        
ring.primaryColor = [UIColor whiteColor]; //The outher color of the ring

ring.secondaryColor = [UIColor colorWithWhite:1.0 alpha:0.6]; //The inner color of the ring
        
ring.indeterminate = YES;// Means that the ring will go in loop

[self addSubview:ring];
        
[ring release];