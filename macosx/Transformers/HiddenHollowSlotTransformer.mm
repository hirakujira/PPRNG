/*
  Copyright (C) 2012 chiizu
  chiizu.pprng@gmail.com
  
  This file is part of PPRNG.
  
  PPRNG is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  
  PPRNG is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with PPRNG.  If not, see <http://www.gnu.org/licenses/>.
*/


#import "HiddenHollowSlotTransformer.h"

namespace
{

static NSString  *SlotText[] =
{
  @"Encounter (1%)",
  @"Encounter (4%)",
  @"Encounter (10%)",
  @"Item (1%)",
  @"Item (4%)",
  @"Item (10%)",
  @"Item (25%)",
  @"Dowsing Item (1%)",
  @"Dowsing Item (4%)",
  @"Dowsing Item (10%)",
  @"Dowsing Item (25%)"
};

}

@implementation HiddenHollowSlotTransformer

+ (Class)transformedValueClass
{
  return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

- (id)transformedValue:(id)value
{
  if (value == nil)
    return nil;
  
  if (![value respondsToSelector: @selector(intValue)])
  {
    [NSException raise: NSInternalInconsistencyException
                 format: @"Value (%@) does not respond to -intValue.",
                         [value class]];
  }
  
  return SlotText[[value intValue]];
}

@end
