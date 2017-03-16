typedef struct SBIconCoordinate {
    NSUInteger row;
    NSUInteger col;
} SBIconCoordinate;

struct SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
    SBIconCoordinate coordinate;
    coordinate.row = row;
    coordinate.col = col;
    return coordinate;
}

%hook SBIconListView

- (struct SBIconCoordinate)iconCoordinateForIndex:(unsigned int)index forOrientation:(UIInterfaceOrientation)orientation {
    SBIconCoordinate orig = %orig;
    if (orientation == UIInterfaceOrientationLandscapeRight) {

        if (index == 0)
            return SBIconCoordinateMake(4,1);
        else if (index == 1)
            return SBIconCoordinateMake(3,1);
        else if (index == 2)
            return SBIconCoordinateMake(2,1);
        else if (index == 3)
            return SBIconCoordinateMake(1,1);
        else if (index == 4)
            return SBIconCoordinateMake(4,2);
        else if (index == 5)
            return SBIconCoordinateMake(3,2);
        else if (index == 6)
            return SBIconCoordinateMake(3,2);
        else if (index == 7)
            return SBIconCoordinateMake(3,2);
        else return orig;
    }
    else
        return orig;
}
%end