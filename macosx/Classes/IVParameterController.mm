/*
  Copyright (C) 2011-2012 chiizu
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



#import "IVParameterController.h"

using namespace pprng;

namespace
{

const IVs  PerfectIVs(31, 31, 31, 31, 31, 31);
const IVs  PerfectTrickIVs(31, 31, 31, 31, 31, 0);
const IVs  PhysIVs(31, 31, 31, 0, 31, 31);
const IVs  PhysTrickIVs(31, 31, 31, 0, 31, 0);
const IVs  SpecIVs(31, 0, 31, 31, 31, 31);
const IVs  SpecTrickIVs(31, 0, 31, 31, 31, 0);
const IVs  HpLowIVs(30, 0, 30, 30, 30, 30);
const IVs  HpHighIVs(31, 31, 31, 31, 31, 31);
const IVs  HpTrickLowIVs(30, 0, 30, 30, 30, 2);
const IVs  HpTrickHighIVs(31, 31, 31, 31, 31, 3);

}

@implementation IVParameterController

@synthesize  ivPattern;
@synthesize  minHP, minAT, minDF, minSA, minSD, minSP;
@synthesize  maxHP, maxAT, maxDF, maxSA, maxSD, maxSP;
@synthesize  considerHiddenPower;
@synthesize  hiddenType;
@synthesize  minHiddenPower;
@synthesize  isRoamer;

- (void)awakeFromNib
{
  isSettingPattern = NO;
  [self setMinIVs: IVs(0, 0, 0, 0, 0, 0)];
  [self setMaxIVs: IVs(31, 31, 31, 31, 31, 31)];
  
  self.considerHiddenPower = NO;
  self.hiddenType = Element::ANY;
  self.minHiddenPower = 70;
  self.isRoamer = NO;
}

- (IVPattern::Type)determineIVPattern
{
  IVs  minIVs = [self minIVs], maxIVs = [self maxIVs];
  
  if ((minIVs == PerfectIVs) && (maxIVs == PerfectIVs))
  {
    return IVPattern::HEX_FLAWLESS;
  }
  else if ((minIVs == PerfectTrickIVs) && (maxIVs == PerfectTrickIVs))
  {
    return IVPattern::HEX_FLAWLESS_TRICK;
  }
  else if (((minIVs.word & PhysIVs.word) == PhysIVs.word) &&
           ((maxIVs.word & PhysIVs.word) == PhysIVs.word))
  {
    return IVPattern::PHYSICAL_FLAWLESS;
  }
  else if (((minIVs.word & PhysIVs.word) == PhysTrickIVs.word) &&
           ((maxIVs.word & PhysIVs.word) == PhysTrickIVs.word))
  {
    return IVPattern::PHYSICAL_FLAWLESS_TRICK;
  }
  else if (((minIVs.word & SpecIVs.word) == SpecIVs.word) &&
           ((maxIVs.word & SpecIVs.word) == SpecIVs.word))
  {
    return IVPattern::SPECIAL_FLAWLESS;
  }
  else if (((minIVs.word & SpecIVs.word) == SpecTrickIVs.word) &&
           ((maxIVs.word & SpecIVs.word) == SpecTrickIVs.word))
  {
    return IVPattern::SPECIAL_FLAWLESS_TRICK;
  }
  else if (considerHiddenPower && (minHiddenPower == 70))
  {
    if (minIVs.betterThanOrEqual(HpLowIVs) &&
        maxIVs.worseThanOrEqual(HpHighIVs))
    {
      return IVPattern::SPECIAL_HIDDEN_POWER_FLAWLESS;
    }
    else if (minIVs.betterThanOrEqual(HpTrickLowIVs) &&
             maxIVs.worseThanOrEqual(HpTrickHighIVs))
    {
      return IVPattern::SPECIAL_HIDDEN_POWER_FLAWLESS_TRICK;
    }
  }
  
  return IVPattern::CUSTOM;
}

- (void)setIvPattern:(IVPattern::Type)newIvPattern
{
  if (newIvPattern != ivPattern)
  {
    ivPattern = newIvPattern;
    isSettingPattern = YES;
    
    if (ivPattern != IVPattern::CUSTOM)
    {
      BOOL shouldCheckHiddenPower = NO;
      
      switch (ivPattern)
      {
      case IVPattern::HEX_FLAWLESS:
        [self setMinIVs: PerfectIVs];
        [self setMaxIVs: PerfectIVs];
        break;
        
      case IVPattern::HEX_FLAWLESS_TRICK:
        [self setMinIVs: PerfectTrickIVs];
        [self setMaxIVs: PerfectTrickIVs];
        break;
        
      case IVPattern::PHYSICAL_FLAWLESS:
        [self setMinIVs: PhysIVs];
        [self setMaxIVs: PerfectIVs];
        break;
        
      case IVPattern::PHYSICAL_FLAWLESS_TRICK:
        [self setMinIVs: PhysTrickIVs];
        [self setMaxIVs: PerfectTrickIVs];
        break;
        
      case IVPattern::SPECIAL_FLAWLESS:
        [self setMinIVs: SpecIVs];
        [self setMaxIVs: PerfectIVs];
        break;
        
      case IVPattern::SPECIAL_FLAWLESS_TRICK:
        [self setMinIVs: SpecTrickIVs];
        [self setMaxIVs: PerfectTrickIVs];
        break;
        
      case IVPattern::SPECIAL_HIDDEN_POWER_FLAWLESS:
        [self setMinIVs: HpLowIVs];
        [self setMaxIVs: HpHighIVs];
        shouldCheckHiddenPower = YES;
        break;
        
      case IVPattern::SPECIAL_HIDDEN_POWER_FLAWLESS_TRICK:
        [self setMinIVs: HpTrickLowIVs];
        [self setMaxIVs: HpTrickHighIVs];
        shouldCheckHiddenPower = YES;
        break;
      
      case IVPattern::CUSTOM:
      default:
        return;
        break;
      }
      
      self.considerHiddenPower = shouldCheckHiddenPower;
      self.minHiddenPower = 70;
    }
    isSettingPattern = NO;
  }
}

- (void)setMinHP:(uint32_t)newValue
{
  if (newValue != minHP)
  {
    minHP = newValue;
    
    if (maxHP < minHP)
    {
      self.maxHP = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMinAT:(uint32_t)newValue
{
  if (newValue != minAT)
  {
    minAT = newValue;
    
    if (maxAT < minAT)
    {
      self.maxAT = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMinDF:(uint32_t)newValue
{
  if (newValue != minDF)
  {
    minDF = newValue;
    
    if (maxDF < minDF)
    {
      self.maxDF = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMinSA:(uint32_t)newValue
{
  if (newValue != minSA)
  {
    minSA = newValue;
    
    if (maxSA < minSA)
    {
      self.maxSA = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMinSD:(uint32_t)newValue
{
  if (newValue != minSD)
  {
    minSD = newValue;
    
    if (maxSD < minSD)
    {
      self.maxSD = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMinSP:(uint32_t)newValue
{
  if (newValue != minSP)
  {
    minSP = newValue;
    
    if (maxSP < minSP)
    {
      self.maxSP = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (IVs)minIVs
{
  IVs  result;
  
  result.hp(minHP);
  result.at(minAT);
  result.df(minDF);
  result.sa(minSA);
  result.sd(minSD);
  result.sp(minSP);
  
  return result;
}

- (void)setMinIVs:(IVs)ivs
{
  self.minHP = ivs.hp();
  self.minAT = ivs.at();
  self.minDF = ivs.df();
  self.minSA = ivs.sa();
  self.minSD = ivs.sd();
  self.minSP = ivs.sp();
}

- (void)setMaxHP:(uint32_t)newValue
{
  if (newValue != maxHP)
  {
    maxHP = newValue;
    
    if (maxHP < minHP)
    {
      self.minHP = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMaxAT:(uint32_t)newValue
{
  if (newValue != maxAT)
  {
    maxAT = newValue;
    
    if (maxAT < minAT)
    {
      self.minAT = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMaxDF:(uint32_t)newValue
{
  if (newValue != maxDF)
  {
    maxDF = newValue;
    
    if (maxDF < minDF)
    {
      self.minDF = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMaxSA:(uint32_t)newValue
{
  if (newValue != maxSA)
  {
    maxSA = newValue;
    
    if (maxSA < minSA)
    {
      self.minSA = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMaxSD:(uint32_t)newValue
{
  if (newValue != maxSD)
  {
    maxSD = newValue;
    
    if (maxSD < minSD)
    {
      self.minSD = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMaxSP:(uint32_t)newValue
{
  if (newValue != maxSP)
  {
    maxSP = newValue;
    
    if (maxSP < minSP)
    {
      self.minSP = newValue;
    }
    
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (IVs)maxIVs
{
  IVs  result;
  
  result.hp(maxHP);
  result.at(maxAT);
  result.df(maxDF);
  result.sa(maxSA);
  result.sd(maxSD);
  result.sp(maxSP);
  
  return result;
}

- (void)setMaxIVs:(IVs)ivs
{
  self.maxHP = ivs.hp();
  self.maxAT = ivs.at();
  self.maxDF = ivs.df();
  self.maxSA = ivs.sa();
  self.maxSD = ivs.sd();
  self.maxSP = ivs.sp();
}

- (void)setConsiderHiddenPower:(BOOL)newValue
{
  if (considerHiddenPower != newValue)
  {
    considerHiddenPower = newValue;
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (void)setMinHiddenPower:(uint32_t)newPower
{
  if (minHiddenPower != newPower)
  {
    minHiddenPower = newPower;
    if (!isSettingPattern)
      self.ivPattern = [self determineIVPattern];
  }
}

- (uint32_t)numberOfIVCombinations
{
  IVs  minIVs = [self minIVs];
  IVs  maxIVs = [self maxIVs];
  
  uint32_t  result = (maxIVs.hp() - minIVs.hp() + 1) *
                     (maxIVs.at() - minIVs.at() + 1) *
                     (maxIVs.df() - minIVs.df() + 1) *
                     (maxIVs.sa() - minIVs.sa() + 1) *
                     (maxIVs.sd() - minIVs.sd() + 1) *
                     (maxIVs.sp() - minIVs.sp() + 1);
  return result;
}

@end
