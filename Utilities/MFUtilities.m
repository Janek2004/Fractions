//
//  MFUtilities.m
//  MathFractions
/*
 Author: Janusz Chudzynski
 The MIT License (MIT)
 
 Copyright 2010 University of West Florida. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
#import "KxIntroViewController.h"
#import "KxIntroViewPage.h"
#import "KxIntroView.h"

#import "MFUtilities.h"

@interface MFUtilities()
@property (nonatomic,strong)  KxIntroViewController *vc;
@end

@implementation MFUtilities


/*
 About the  FracTiO App:
 
 This mobile app was design based on learning trajectory perspectives, supports grades 3-6 students’ development of fraction understanding that aligns with the Common Core State Standards for Mathematics. Teachers and students could use this app for teaching and learning of function concept.  This app include three of the Common Core State Standards Mathematics:
 1. CCSS.Math.Content.3.NF.A.1. Understand a fraction 1/b as the quantity formed by 1 part when a whole is partitioned into b equal parts; understand a fraction a/b as the quantity formed by a parts of size 1/b.
 
 
 
 2. CCSS.Math.Content.3.NF.A.2 Understand a fraction as a number on the number line; represent fractions on a number line diagram.
 
 CCSS.Math.Content.3.NF.A.3.Explain equivalence of fractions in special cases, and compare fractions by reasoning about their size.

 
 */

-(void)presentIntroIn:(id)viewcontroller{
    KxIntroViewPage *page0 = [KxIntroViewPage introViewPageWithTitle: @"Math Fractions"
                                                          withDetail: @"That will be intro to the fractions app"
                                                           withImage: [UIImage imageNamed:@"titlepage"]];
    
    KxIntroViewPage *page1 = [KxIntroViewPage introViewPageWithTitle: @"About US"
                                                          withDetail: @"List of new features\n\n- feature #1\n- feature #2\n- feature #3\n- feature #4\n- feature #5"
                                                           withImage: [UIImage imageNamed:@"fractio"]];

    
    page0.fullScreenImage = YES;
    page1.detailLabel.textAlignment = NSTextAlignmentLeft;
    
    KxIntroViewController *vc = [[KxIntroViewController alloc ] initWithPages:@[ page0, page1 ]];
    vc.introView.animatePageChanges = YES;
    vc.introView.gradientBackground = YES;
    void (^handler)()=^(){
        NSLog(@"Handler 2 got called");
    };
    
    vc.completionHandler =handler;
    [vc presentInViewController:viewcontroller fullScreenLayout:YES];

}


-(void)presentIntroForActivity:(int)activity inViewController: (id)viewcontroller{
  //probably we can store it in database file
#warning store it in database
    if(activity == 1||activity == 2||activity == 3)
    {
        [self presentScaleIntro:viewcontroller];
    }
    if(activity == 5||activity == 6)
    {
       [self presentNumberLineIntro:viewcontroller];
    }
    if(activity == 4)
    {

       [self presentFillGlassIntro:viewcontroller];
    }
    
    
    
}

-(void)presentScaleIntro:(id)viewcontroller{
    KxIntroViewPage *page0 = [KxIntroViewPage introViewPageWithTitle: @"Scale Activity"
                                                          withDetail: @"That will be intro to the fractions app"
                                                           withImage: [UIImage imageNamed:@"holdweight@2"]];
    
    KxIntroViewPage *page1 = [KxIntroViewPage introViewPageWithTitle: @"What's new in fractions"
                                                          withDetail: @"List of new features\n\n- feature #1\n- feature #2\n- feature #3\n- feature #4\n- feature #5"
                                                           withImage: [UIImage imageNamed:@"holdweight@2"]];
    
    
    page1.detailLabel.textAlignment = NSTextAlignmentLeft;
    
    KxIntroViewController *vc = [[KxIntroViewController alloc ] initWithPages:@[ page0, page1 ]];
    vc.introView.animatePageChanges = YES;
    vc.introView.gradientBackground = YES;
   //[vc presentInViewController:viewcontroller fullScreenLayout:YES];
    void (^handler)()=^(){
        [vc.view removeFromSuperview];
    };
    
    vc.completionHandler =handler;
    
    [vc presentInView:[(UIViewController *) viewcontroller view]];

    
}

-(void)presentNumberLineIntro:(id)viewcontroller{
    KxIntroViewPage *page0 = [KxIntroViewPage introViewPageWithTitle: @"Number Line Intro Activity"
                                                          withDetail: @"That will be intro to the fractions app"
                                                           withImage: [UIImage imageNamed:@"holdchoco@2"]];
    
    KxIntroViewPage *page1 = [KxIntroViewPage introViewPageWithTitle: @"What's new in fractions"
                                                          withDetail: @"List of new features\n\n- feature #1\n- feature #2\n- feature #3\n- feature #4\n- feature #5"
                                                           withImage: [UIImage imageNamed:@"holdchoco@2"]];
    
    
    page1.detailLabel.textAlignment = NSTextAlignmentLeft;
    
    KxIntroViewController *vc = [[KxIntroViewController alloc ] initWithPages:@[ page0, page1 ]];

    vc.introView.animatePageChanges = YES;
    vc.introView.gradientBackground = YES;
    void (^handler)()=^(){
       [vc.view removeFromSuperview];
    };
    
    vc.completionHandler =handler;
    [vc presentInView:[(UIViewController *) viewcontroller view]];


    
}

-(void)presentFillGlassIntro:(id)viewcontroller{
    KxIntroViewPage *page0 = [KxIntroViewPage introViewPageWithTitle: @"Fill the Glass Activity"
                                                          withDetail: @"That will be intro to the fractions app"
                                                           withImage: [UIImage imageNamed:@"holdcup@2"]];
    
    KxIntroViewPage *page1 = [KxIntroViewPage introViewPageWithTitle: @"What's new in fractions"
                                                          withDetail: @"List of new features\n\n- feature #1\n- feature #2\n- feature #3\n- feature #4\n- feature #5"
                                                           withImage: [UIImage imageNamed:@"holdcup@2"]];
    
    
    page1.detailLabel.textAlignment = NSTextAlignmentLeft;
    
    KxIntroViewController *vc = [[KxIntroViewController alloc ] initWithPages:@[ page0, page1 ]];
    
    vc.introView.animatePageChanges = YES;
    vc.introView.gradientBackground = YES;
    void (^handler)()=^(){
        [vc.view removeFromSuperview];
    };
    
    vc.completionHandler =handler;
    [vc presentInView:[(UIViewController *) viewcontroller view]];
    
}

-(float)getValueOfFraction:(MFFraction *)fraction;{
     return fraction.numerator*1.0/fraction.denominator*1.0;

}


- (NSComparisonResult)compare:(MFFraction *)fractionOne and:(MFFraction *)otherObject {
    float a =  fractionOne.numerator/fractionOne.denominator;
    float b = otherObject.numerator/otherObject.denominator;
    if(a==b)
    {
        return NSOrderedSame;
    }
    if(a<b){
        return NSOrderedAscending;
    }
    return NSOrderedDescending;
}

- (BOOL)isEqual:(MFFraction *)fractionOne and:(MFFraction *)object
{
   MFFraction * other = (MFFraction *)object;
    fractionOne = [self simplify:fractionOne];
    other = [self simplify:other];
    
  return fractionOne.numerator == other.numerator && fractionOne.denominator == other.denominator;
  
}

-(MFFraction *)simplify:(MFFraction *)_fraction{
  
    int a = _fraction.numerator;
    int b = _fraction.denominator;
    
    long gcm = GCD(a, b);
    a = a/gcm;
    b= b/gcm;
    _fraction.numerator = a;
    _fraction.denominator = b;
    
    return _fraction;
}

int GCD(int a, int b){
    if (b==0) return a;
    return GCD(b,a%b);
}

@end
