//
//  MailHelper.m
//  MathFractions
//
//  Created by Janusz Chudzynski on 11/25/13.
//  Copyright (c) 2013 UWF. All rights reserved.
//

#import "MailHelper.h"
@import MessageUI;
@interface MailHelper()<MFMailComposeViewControllerDelegate>
@property (nonatomic,strong)UIViewController * vc;
@end
@implementation MailHelper 

-(void)sendEmailFromVC:(id)vc{
if([MFMailComposeViewController canSendMail])
{
    _vc= vc;
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [mailer setToRecipients:@[@"jchudzynski@uwf.edu",@"gnguyen@uwf.edu"]];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"Contact Fractio Support"];

    NSMutableString *body = [NSMutableString string];
    // add HTML before the link here with line breaks (\n)
    [body appendString:@"Please describe your concerns or questions below:<br>\n"];
    [body appendString:@"Our team will do their best to help you.<br>\n"];
    
    [body appendString:@"Thanks much! <br> \n"];
    [mailer setMessageBody:body isHTML:YES];
    
    // only for iPad
    mailer.modalPresentationStyle = UIModalPresentationPageSheet;
    [vc presentViewController:mailer animated:YES completion:nil];
    
}
else
{
    NSLog(@"Share URL 3");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                    message:@"Your device doesn't support the composer sheet"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}
}

#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
