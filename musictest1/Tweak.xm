%hook RadioAvailabilityController
		-(BOOL)isRadioAvailable {
			return NO; 
		}
		%end
