//
//  PaymentDetail1ViewController.h
//  firstsSwype
//
//  Created by My Work Force on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioAnalyLib.h"

@interface PaymentDetail1ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    
    AudioAnalyLib *mAudioLib;
	UITextView *mTextView;
	char szRecvBuf[1200];
    IBOutlet UIPickerView *expDate;
    //IBOutlet UIPickerView *cardType;
    //IBOutlet UIButton *doneCardTypeButton;
    NSArray *months;
    NSArray *year;
    NSString *selmonth;
    NSString *selyear;
    NSString *urlString;
    NSString *selectedCard;
    IBOutlet UIButton *dateVallue;
    IBOutlet UITextField *name;
    IBOutlet UITextField *creditCardNo;
    IBOutlet UITextField *cvvNo;
    IBOutlet UITextField *email;
    IBOutlet UITextField *amount;
    IBOutlet UITextField *phone;
	IBOutlet UITextField *ccType;
    NSMutableArray *state;
    BOOL keyboardVisible;
    BOOL viewShiftedForKeyboard;
    NSTimeInterval keyboardSlideDuration;
    CGFloat keyboardShiftAmount;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *cardVallue;
    NSString *date;
    NSString *nam;
    NSString *ccno;
    NSUserDefaults *standardUserDefault;
    NSInteger tempidentity;
    NSData *responseData;
}
@property(nonatomic, retain) NSData *responseData;
@property(nonatomic, retain) NSUserDefaults *standardUserDefault;
@property(nonatomic, retain) NSString *date;
@property(nonatomic, retain) NSString *nam;
@property(nonatomic, retain) NSString *ccno;
@property(nonatomic, retain) NSString *urlString;
@property(nonatomic, retain) NSMutableArray *state;
//@property(nonatomic, retain) IBOutlet UIButton *doneCardTypeButton;
//@property(nonatomic, retain) IBOutlet UIPickerView *cardType;
@property(nonatomic, retain) IBOutlet UITextField *ccType;
@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UITextField *phone;
@property(nonatomic, retain) IBOutlet UITextField *amount;
@property(nonatomic, retain) IBOutlet UIButton *doneButton;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UITextField *name;
@property(nonatomic, retain) IBOutlet UITextField *creditCardNo;
@property(nonatomic, retain) IBOutlet UITextField *cvvNo;
@property(nonatomic, retain) IBOutlet UIButton *dateVallue;
@property(nonatomic, retain) NSString *selmonth;
@property(nonatomic, retain) NSString *selyear;
@property(nonatomic, retain) NSArray *months;
@property(nonatomic, retain) NSArray *year;
@property(nonatomic, retain) IBOutlet UIPickerView *expDate;
@property(nonatomic, retain) IBOutlet UIButton *cardVallue;
-(IBAction)Change:(id)sender;
//-(IBAction)reSwipe:(id)sender;
-(IBAction)reEvent:(id)sender;
-(IBAction)showdatepickerview:(id)sender;
//-(IBAction)showcardpickerview:(id)sender;
-(IBAction)approve:(id)sender;
-(void)keyboardDidShow: (NSNotification *) notif;
-(void)keyboardDidHide: (NSNotification *) notif;

@end

