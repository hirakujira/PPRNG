/*
  Copyright (C) 2011 chiizu
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


#import "Utilities.h"

using namespace pprng;

NSString* NatureString(pprng::Nature::Type nature)
{
  return @"";
}

NSString* GenderString(PID pid)
{
  uint32_t  genderValue = pid.GenderValue();
  
  if (genderValue < 31)
  {
    return @"F/F/F/F";
  }
  else if (genderValue < 63)
  {
    return @"M/F/F/F";
  }
  else if (genderValue < 127)
  {
    return @"M/M/F/F";
  }
  else if (genderValue < 191)
  {
    return @"M/M/M/F";
  }
  else
  {
    return @"M/M/M/M";
  }
}

/*
NSString* GenderString(PID pid)
{
  uint32_t  genderValue = pid.GenderValue();
  
  if (genderValue < 31)
  {
    return @"≥ 12.5%";
  }
  else if (genderValue < 63)
  {
    return @"≥ 25%";
  }
  else if (genderValue < 127)
  {
    return @"≥ 50%";
  }
  else if (genderValue < 191)
  {
    return @"≥ 75%";
  }
  else
  {
    return @"100% ♂";
  }
}
*/

NSString* HeldItemString(HeldItem::Type t)
{
  switch (t)
  {
  case HeldItem::FIFTY_PERCENT_ITEM:
    return @"50%";
    break;
    
  case HeldItem::FIVE_PERCENT_ITEM:
    return @"5%";
    break;
    
  case HeldItem::ONE_PERCENT_ITEM:
    return @"1%";
    break;
    
  case HeldItem::NO_ITEM:
  default:
    return @"";
    break;
  }
}