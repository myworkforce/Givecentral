//
//  PaymentDetailViewController.m
//  firstsSwype
//
//  Created by Administrator on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PaymentDetailViewController.h"
#import "eventViewController.h"
#import "paymentinfoViewController.h"
#import "PaymentDetail1ViewController.h"
#import "SwipeViewController.h"
#import "AudioAnalyData.h"
#import "DUKPT_DES.h"
#import "String.h"


static unsigned char  MainKey[16],NowKey[16],RealOutData[500];

#define TIME_FIELD    1
#define PICKER_ANIMATION_DURATION	0.3
#define PICKER_ANIMATION_DELAY		0.6

@implementation PaymentDetailViewController

@synthesize expDate,standardUserDefault,selyear,selmonth,months,year,dateVallue,name,doneButton,cvvNo,creditCardNo,scrollView,amount,email,cardVallue,phone,ccType,state,urlString,date,ccno,nam,responseData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(void) SpreatDecodeCardData:( NSString*) strin  stroutgo:(NSString **)strout 
{
    
    NSString *tempString;
    unsigned int i,j=0;unsigned int cPos[20];unsigned long lCount = 0;
    
    unsigned char tempbuf[5];
    
    
    char EncryptData[500]; unsigned char EncryptDataSouce[256],ucTmpData[300];
    char CardNumber[50];
    char First6cardNum[20];
    char Last4cardNum[10];
    char Name[60];
    char ExpireDate[10];
    char ServiceCode[5];
    
    char KSN[30]; unsigned char KSNSouce[15];
    char CheckSum[5];unsigned char CheckSumSouce, ucCheck,ucCheckLen;
    
    
    memset(cPos, 0, sizeof(cPos));
    
    memset(EncryptData,0,sizeof(EncryptData));
    memset(CardNumber,0,sizeof(CardNumber));
    memset(First6cardNum,0,sizeof(First6cardNum));
    memset(Last4cardNum,0,sizeof(Last4cardNum));
    memset(Name,0,sizeof(Name));
    memset(ExpireDate,0,sizeof(ExpireDate));
    memset(ServiceCode,0,sizeof(ServiceCode));
    memset(KSN,0,sizeof(KSN));
    memset(CheckSum,0,sizeof(CheckSum));
    
    
    //const char *szTmp="00000000000";
    
    if (strin&&strin.length>10) {
        
        
        
        const char *szTmp = [strin UTF8String] ;
        
        for( i=0;i< strin.length;i++){
            if(szTmp[i] =='^'){
                cPos[j++] = i;
                
            }
        }
        
        memcpy(EncryptData, szTmp+1, cPos[0]-1);
        memcpy(First6cardNum, szTmp+cPos[0]+1, 6);
        memcpy(Last4cardNum, szTmp+cPos[1]+1 , 4);
        memcpy(Name, szTmp +cPos[2]+1, 26);
        memcpy(ExpireDate, szTmp + cPos[3]+1, 4);
        memcpy(ServiceCode, szTmp + cPos[4]+1, 3);
        memcpy(KSN, szTmp + cPos[5]+1 , 20);
        memcpy(CheckSum, szTmp + cPos[6]+1 , 2);
        
        
        
        vTwoOne((unsigned char *)EncryptData, cPos[0]-1,(unsigned char *)EncryptDataSouce);
        vTwoOne((unsigned char *)KSN,20,(unsigned char *)KSNSouce);
        vTwoOne((unsigned char *)CheckSum,2,&CheckSumSouce);
        
        memcpy(ucTmpData,EncryptDataSouce,(cPos[0]-1)/2);  
        memcpy(ucTmpData+(cPos[0]-1)/2,First6cardNum,6);
        memcpy(ucTmpData+(cPos[0]-1)/2+6,Last4cardNum,4);
        memcpy(ucTmpData+(cPos[0]-1)/2+6+4,Name,26);
        memcpy(ucTmpData+(cPos[0]-1)/2+6+4+26,ExpireDate,4);
        memcpy(ucTmpData+(cPos[0]-1)/2+6+4+26+4,ServiceCode,3);
        memcpy(ucTmpData+(cPos[0]-1)/2+6+4+26+4+3,KSNSouce,10);  
        
        
        ucCheckLen = (cPos[0]-1)/2  + 6 + 4 + 26 + 4 + 3 + 10  ;
        
        ucCheck = 0xff;  
        
        for (i=0; i<(ucCheckLen); i++) {
            ucCheck ^= ucTmpData[i];
        }    
        
        //  printf("ucCheck = [%02X],[%2X] ,%d\n",ucCheck,CheckSumSouce,ucCheckLen);
        
        if(ucCheck == CheckSumSouce){    
            
            memcpy(MainKey,"\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff",16);
            
            memcpy(tempbuf,KSNSouce+7,3);
            tempbuf[0] = tempbuf[0]& 0x1F;
            lCount = tempbuf[0]* 0x10000+tempbuf[1]* 0x100+tempbuf[2];
            
            
            pan_count(&lCount);        //transaction count 
            
            get_now_key(NowKey, MainKey, &lCount, KSNSouce);//   every swipe , NowKey is different.
            
            memset(RealOutData, 0, sizeof(RealOutData));
            Des_string((unsigned char *)EncryptDataSouce , (cPos[0]-1)/2 , NowKey, 16,RealOutData , TDES_DECRYPT);//decode  EncryptDataSouce to RealOutData
            
            
            for( i=0;i< strin.length;i++){
                if(RealOutData[i] ==';')
                    cPos[0] = i;
                if(RealOutData[i] =='=')
                    cPos[1] = i;
                
            }
            memcpy(CardNumber,RealOutData+cPos[0]+1,cPos[1]-cPos[0]-1);
            
            
            /*
             printf("EncryptDataSouce  : [%d]",(cPos[0]-1)/2);
             for (i=0 ;i< (cPos[0]-1)/2 ; i++){
             printf("0x%02X,",EncryptDataSouce[i]);
             }
             
             printf("\nRealOutData  :[%s]\n",RealOutData);
             */
            tempString = [NSString stringWithCString:(const char *)RealOutData encoding:NSUTF8StringEncoding];// decoded card data 
            
            //NSString *string2;
            
            ccno = [tempString substringWithRange: NSMakeRange (2, 16)];
            
            NSLog (@"string2 = %@", ccno);
            NSLog(@"OnSwipeCompletedgdfskjnbvkjjdhsfbkvjhdkjzbnv %@",tempString);
            NSArray *myArray = [tempString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"^"]];
            NSLog(@"%@",[myArray objectAtIndex:0]);
            NSLog(@"%@",[myArray objectAtIndex:1]);
            NSLog(@"%@",[myArray objectAtIndex:2]);
            NSString *str = [[NSString alloc] initWithString:[[myArray objectAtIndex:2] substringWithRange: NSMakeRange (0, 4)]];
            selyear = [[NSString alloc] initWithFormat:@"20%@",[str  substringWithRange: NSMakeRange (0, 2)]];
            selmonth = [[NSString alloc] initWithFormat:@"%@",[str substringWithRange: NSMakeRange (2, 2)]];
            date = [[NSString alloc] initWithFormat:@"%@-%@",selyear,[months objectAtIndex:(selmonth.integerValue-1)]];
             NSLog(@"date   %@",date);
            /*NSArray *myArray1 = [[myArray objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"^"]];
            NSLog(@"%@",[myArray1 objectAtIndex:0]);
            NSLog(@"%@",[myArray1 objectAtIndex:1]);*/
            nam = [myArray objectAtIndex:1];
            NSString* result = [nam stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            nam = [result stringByReplacingOccurrencesOfString:@"/" withString:@""];
            //NSArray *myArray2 = [[myArray objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            //NSLog(@"%@",[myArray2 objectAtIndex:0]);
            NSLog(@"name     %@",nam);
            *strout = [*strout stringByAppendingFormat:@"[Encrypt Data:] %s\n[Card Data:]\n %@ \n[CardNumber:]  %s \n[First6cardNum:]  %s  [Last4cardNum:]  %s\n[Name:]  %s \n[ExpireDate:]  %s     [ServiceCode:]  %s \n [KSN:]  %s [CheckSum:]  %s\n ",EncryptData,tempString,CardNumber,First6cardNum,Last4cardNum,Name,ExpireDate,ServiceCode,KSN,CheckSum];
            //ccno = [NSString stringWithFormat:@"%s",(NSString *)CardNumber];
            //nam = [NSString stringWithFormat:@"%s",Name];
            //date = [NSString stringWithFormat:@"%s",ExpireDate];
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Swipe Success" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            //[self.view addSubview:alert];
            
            //[self.view bringSubviewToFront:alert];
            //[alert bringSubviewToFront:self.view];
            //[alert show];
            //[self.view removeFromSuperview];
            
            //[mAudioLib.delegate release];
            NSLog(@"OnSwipeCompleted %@",date);
            NSLog(@"OnSwipeCompleted %@",nam);
            NSLog(@"OnSwipeCompleted %@",ccno);
            [creditCardNo setText:ccno];
            [name setText:nam];
            
            [dateVallue setTitle:date forState:0];
            standardUserDefault = [NSUserDefaults alloc];
            [standardUserDefault setObject:ccno forKey:@"ccno"];
            [standardUserDefault setObject:nam forKey:@"name"];
            [standardUserDefault setObject:date forKey:@"date"];
            //[self performSelector:@selector(Change:)];
            //[alert dismissWithClickedButtonIndex:0 animated:YES];
            
            
        }
        else{
            printf("CheckSum ERROR");
            
            // to do what you want to do here
            return;
        }
        
    }else
        return;
    
    
}

- (void) startThreadButtonPressed:(id) sender{
	
	/*threadStartButton.hidden = YES;
	threadValueLabel.text = @"0";
	threadProgressView.progress = 0.0;*/
    //thread = [[NSThread alloc] init];
    
	[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
	
}

- (void)startTheBackgroundJob {
	
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	// wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time
	//[NSThread sleepForTimeInterval:3];
    mAudioLib = [[AudioAnalyLib alloc] init];
    [standardUserDefault setObject:mAudioLib forKey:@"maudio"];
    mAudioLib.delegate = self;
    mAudioLib.OnDevicePluggedIn = @selector(OnDevicePluggedIn);
    [mAudioLib StartDevice];
    [mAudioLib WaitForSwipe:20];
    mAudioLib.OnNoDevicePluggedIn = @selector(OnNoDevicePluggedIn);
    //[self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
    //[pool release];
	
}

- (void)makeMyProgressBarMoving {
    
	//float actual = [threadProgressView progress];
	//threadValueLabel.text = [NSString stringWithFormat:@"%.2f", actual];
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
	if ([standardUserDefault objectForKey:@"done"] == @"done") {
		//threadProgressView.progress = actual + 0.01;
    NSLog(@"shubham");
		//[self performSelector:@selector(Change:) onThread:thread withObject:nil waitUntilDone:YES]; 
        //[self performSelectorOnMainThread:@selector(Change:) withObject:self waitUntilDone:YES];
	}
	
}


-(void)Change:(id)sender
{
    NSLog(@"change");
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    
    PaymentDetail1ViewController *paymentDetail1ViewController = [[PaymentDetail1ViewController alloc] initWithNibName:@"PaymentDetail1ViewController" bundle:nil];
    [navigationController pushViewController:paymentDetail1ViewController animated:NO];
    //[self presentModalViewController:paymentDetail1ViewController animated:YES];
    [standardUserDefault setValue:@"yes" forKey:@"swipe"];
    /*PaymentDetail1ViewController *page = [[PaymentDetail1ViewController alloc] initWithNibName:@"PaymentDetail1ViewController" bundle:nil];
    CGRect theFrame = page.view.frame;
    theFrame.origin = CGPointMake(self.view.frame.size.width, 0);
    page.view.frame = theFrame;
    theFrame.origin = CGPointMake(0,0);
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.8f];
    page.view.frame = theFrame;
    [UIView commitAnimations];
    [self.view addSubview:page.view];
    [page release];*/
    NSLog(@"changed");
}

- (void)viewDidLoad
{
    [self performSelector:@selector(startThreadButtonPressed:) withObject:nil];
    standardUserDefault = [NSUserDefaults standardUserDefaults];
    //standardUserDefault = [NSUserDefaults standardUserDefaults];
   /* if ([standardUserDefault objectForKey:@"swipe"]==@"yes") {
        NSLog(@"swipe");
        mAudioLib = [standardUserDefault objectForKey:@"maudio"];
        //mAudioLib.delegate = self;
        
    }
    else {
        NSLog(@"noswipe");
        mAudioLib = [[AudioAnalyLib alloc] init];
        [standardUserDefault setObject:mAudioLib forKey:@"maudio"];
        mAudioLib.delegate = self;
        mAudioLib.OnDevicePluggedIn = @selector(OnDevicePluggedIn);
        [mAudioLib StartDevice];
        [mAudioLib WaitForSwipe:20];
        mAudioLib.OnNoDevicePluggedIn = @selector(OnNoDevicePluggedIn);
    }*/
    
    
    scrollView.contentSize =  self.view.frame.size;
    name.returnKeyType = UIReturnKeyDone;
    name.delegate = self;
    creditCardNo.returnKeyType = UIReturnKeyDone;
    creditCardNo.delegate = self;
    //cvvNo.returnKeyType = UIReturnKeyDone;
    //cvvNo.delegate = self;
    email.returnKeyType = UIReturnKeyDone;
    email.delegate = self;
    ccType.returnKeyType = UIReturnKeyDone;
    ccType.delegate = self;
    amount.returnKeyType = UIReturnKeyDone;
    amount.delegate = self;
    phone.returnKeyType = UIReturnKeyDone;
    phone.delegate = self;
    standardUserDefault = [NSUserDefaults standardUserDefaults];
    
    //ccType = [[NSMutableArray alloc]init];
    //[ccType addObjectsFromArray:[NSArray arrayWithObjects:@"American Express",@"Discover",@"Master Card",@"Visa", nil]];
    months =[[NSArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    year = [[NSArray alloc]initWithObjects:@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",@"2022",@"2023",@"2024",@"2025",@"2026",@"2027",@"2028",@"2029",@"2030",@"2031",@"2032",@"2033",@"2034",@"2035",@"2036",@"2037",@"2038",@"2039",@"2040",@"2041",@"2042",@"2043",@"2044",@"2045",@"2046",@"2047",@"2048",@"2049",@"2050", nil];
    //[cardType selectRow:1 inComponent:0 animated:NO];
    //selectedCard = [ccType objectAtIndex:[cardType selectedRowInComponent:0]];
    responseData = [[NSMutableData alloc] init];
	
	
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



/*-(void)reSwipe:(id)sender{
    
    
    [standardUserDefault setValue:@"yes" forKey:@"swipe"];
       SwipeViewController *swipeViewController = [[SwipeViewController alloc] initWithNibName:@"SwipeViewController" bundle:nil];
    [self performSelector:@selector(done)];
    [self.navigationController pushViewController:swipeViewController animated:YES];
}*/
-(void)reEvent:(id)sender{  
    [standardUserDefault setValue:@"yes" forKey:@"swipe"];
    
    
    NSArray *array = [[NSArray alloc] init];
    NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *documentPath = [documentFolder stringByAppendingPathComponent:@"event.plist"];
    
    [array writeToFile:documentPath atomically:YES];
    [standardUserDefault setValue:@"yes" forKey:@"swipe"];
    eventViewController *EventViewController = [[eventViewController alloc] initWithNibName:@"eventViewController" bundle:nil];
    //[NSApp relaunch:nil];
    [self.navigationController pushViewController:EventViewController animated:YES];
}



- (void)OnRecvAudioCardData:(TCardCmdRespond *)respond {
    unsigned char CheckSumSouce, ucCheck,ucCheckLen;
    int i; 
	//NSLog(@"OnRecvAudioCardData:%d", respond->iType);
    memset(szRecvBuf, 0, sizeof(szRecvBuf));
    
    if(respond->state !=0xaa){
        //[self performSelectorOnMainThread:@selector(ShowTextView:) withObject:@"Run Command Error!\r\n" waitUntilDone:YES];
    }else{
        
        
        ucCheckLen = respond->iLen -3;
        ucCheck = respond->data[0];
        for (i=0; i<ucCheckLen-1; i++) {
            ucCheck ^= respond->data[i+1];
        }      
        CheckSumSouce = respond->data[ucCheckLen];
        
        if (ucCheck == CheckSumSouce) {
            
            //to do what you want here
            
            
            
            
            
            // printf("ucCheck = [%02X],[%2X] ,%d\n",ucCheck,CheckSumSouce,ucCheckLen);
            
            switch (respond->iType) {
                case CardCmdType_VER:
                    //NSLog(@"GetVersion:%s %d", respond->data,respond->iLen);
                    
                    memcpy(szRecvBuf, respond->data, respond->iLen-3);
                    
                    break;
                case CardCmdType_GETKSN:
                    //NSLog(@"GetKSN:%s", respond->data);
                    
                    vOneTwo0(respond->data, respond->iLen-3,(unsigned char*) szRecvBuf);
                    break;
                case CardCmdType_SETCDKEY:
                    //NSLog(@"SetCDKEY:%s", respond->data);
                    
                    memcpy(szRecvBuf, respond->data, sizeof(respond->data));
                    break;
                case CardCmdType_SETKSN:
                    //NSLog(@"SetKSN:%s", respond->data);
                    
                    memcpy(szRecvBuf, respond->data, sizeof(respond->data));
                    break;
                case CardCmdType_SETMODE:
                    //NSLog(@"SetMode:%s", respond->data);
                    
                    memcpy(szRecvBuf, respond->data, sizeof(respond->data));
                    break;
                default:
                    break;
            }
            if (respond->iLen == 3)    //if iLen ==3 ,means no data response, just Len, cmd, status
                strcpy(szRecvBuf, "Cmd Success AA\r\n" );
            //[self performSelectorOnMainThread:@selector(ShowTextView:) withObject:nil waitUntilDone:YES];
            
        }else{  //if ucCheck != CheckSumSouce
            
            //to do what you want here
            
        }           
        
        
        
    }
    
    
    
}


- (void)OnSwipeCompleted:(NSString *)respond {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // Aotorelease pool   This is importent!!
    NSString *OutData = @"";
    NSLog(@"OnSwipeCompleted %@",respond);
    [standardUserDefault setObject:@"done" forKey:@"done"];
    memset(szRecvBuf, 0, sizeof(szRecvBuf));
    
    [self SpreatDecodeCardData:respond stroutgo:&OutData];//   Decode encrypted card data
    
    //[self performSelectorOnMainThread:@selector(ShowTextView:) withObject:(id)OutData waitUntilDone:YES];
    
    [pool release];// Aotorelease pool   This is importent!!
}


- (void)OnSwipeError:(SwipeErrorState)respond {
    //NSLog(@"OnSwipeError");
    switch (respond) {
		case SwipeErrorStateTrackIncorrectLength:
            
            
            NSLog(@"SwipeErrorStateTrackIncorrectLength");
			break;
        case SwipeErrorStateCRCFail:
            NSLog(@"SwipeErrorStateCRCFail");
			break;
        case SwipeErrorStateSwipeFail:
            strcpy(szRecvBuf, "SwipeErrorStateSwipeFail");
            //[self performSelectorOnMainThread:@selector(ShowTextView:) withObject:nil waitUntilDone:YES];
            NSLog(@"SwipeErrorStateSwipeFail");
			break;
        case SwipeErrorStateUnknownError:
            NSLog(@"SwipeErrorStateUnknownError");
			break;    
        default:
            break;
    }
}

- (void)SendUserData:(UIButton *)sender {
	unsigned char szBuf[50];//send data
    static unsigned long TestL = 1 ;
	switch (sender.tag) {
		case 101:
			//NSLog(@"GetVersion");
			[mAudioLib GetVersion];
			break;
		case 102:
			//NSLog(@"GetKSN");
			[mAudioLib GetKSN];
			break;
		case 103:
			//NSLog(@"SetCDKey");
            // memcpy(szBuf,&TestL,4);
            szBuf[0] = TestL/0x1000000;
            szBuf[1] = TestL/0x10000;
            szBuf[2] = TestL/0x100;
            szBuf[3] = TestL;
            // TestL++;
			[mAudioLib SetCDKey:szBuf];
			break;
		case 104:                 
			//NSLog(@"SetKSN");
            memcpy(szBuf,"\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff",44);
			[mAudioLib SetKSN:szBuf];
			break;
		case 105:
			//NSLog(@"SetSecret");
            
            [mAudioLib SetSecret:NO];
            
			break;
		default:
			break;
	}
}


- (void)StartDevice {
    
    
    [mAudioLib StartDevice];
}

- (void)StopDevice {
    [mAudioLib StopDevice];
    [mAudioLib release];
}

/*- (void)WaitForSwipe {
 
 [self performSelectorOnMainThread:@selector(ShowTextView:) withObject:@"Please Swipe Card......." waitUntilDone:YES];
 [mAudioLib WaitForSwipe:20];// wait 20 sec
 }*/

- (void)OnStopDevice {
    [mAudioLib StopDevice];
    NSLog(@"OnStopDevice");
}


- (void)OnDevicePluggedIn {
    mAudioLib.OnRecvCardData = @selector(OnRecvAudioCardData:);
    mAudioLib.OnStopDevice = @selector(OnStopDevice);
    
    mAudioLib.OnSwipeCompleted = @selector(OnSwipeCompleted:);
    mAudioLib.OnSwipeError = @selector(OnSwipeError:);
    mAudioLib.OnEncryptingData = @selector(OnEncryptingData);
    mAudioLib.OnError = @selector(OnError);
    mAudioLib.OnTimeout = @selector(OnTimeout);
    mAudioLib.OnInterrupted = @selector(OnInterrupted);
    [mAudioLib StartDevice];
    [mAudioLib WaitForSwipe:20];
    NSLog(@"OnDevicePluggedIn");
    
}

- (void)OnNoDevicePluggedIn {
    NSLog(@"OnNoDevicePluggedIn");
}



- (void)OnEncryptingData {
    NSLog(@"OnEncryptingData");
}

- (void)OnError {
    NSLog(@"OnError");
}

- (void)OnTimeout {
    NSLog(@"OnTimeout");
    /*[self performSelectorOnMainThread:@selector(ShowTextView:) withObject:@"Swipe Card  TimeOut!\nPlease Click WaitForSwipe......." waitUntilDone:YES];*/
    [mAudioLib WaitForSwipe:20];
}

- (void)OnInterrupted {
    NSLog(@"OnInterrupted");
}









- (void)done {
    [super viewDidLoad]; //to refresh super view - I think that will work.
    //[self.delegate flipsideViewControllerDidFinish:self];	
}





/*- (IBAction)doneCardAction:(id)sender
{
	
    
	
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.cardType.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PICKER_ANIMATION_DURATION];
	
	// we need to perform some post operations after the animation is complete
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(tempSlideDownDidStop)];
	
	self.cardType.frame = endFrame;
	[UIView commitAnimations];
    
	[cardVallue setTitle:selectedCard forState:0];
	cardType = false;
    [doneCardTypeButton setHidden:true];
    // grow the table back again in vertical size to make room for the date picker
	//	CGRect newFrame = self.tableView.frame;
	//	newFrame.size.height += self.tempPickerView.frame.size.height;
	//	self.tableView.frame = newFrame;
	
	// remove the "Done" button in the nav bar
	//self.navigationItem.rightBarButtonItem = nil;
}
*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    /*if(pickerView == cardType ){
		selectedCard= [ccType objectAtIndex:row];
	}*/
    
    
    
    
}


- (IBAction)doneAction:(id)sender
{
    
    
	
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.expDate.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:PICKER_ANIMATION_DURATION];
	
	// we need to perform some post operations after the animation is complete
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(tempSlideDownDidStop)];
	
	self.expDate.frame = endFrame;
	[UIView commitAnimations];
    NSString *msg = [NSString stringWithFormat: @"%@-%@",[year objectAtIndex:[expDate selectedRowInComponent:1]],
                     [months objectAtIndex:[expDate selectedRowInComponent:0]]];
    NSString *month = [NSString stringWithString:[months objectAtIndex:[expDate selectedRowInComponent:0]]];
    if ([month isEqualToString:@"January"]) {
        selmonth = @"01";
    }
    else if ([month isEqualToString:@"February"]) {
        selmonth = @"02";
    }
    else if ([month isEqualToString:@"March"]) {
        selmonth = @"03";
    }
    else if ([month isEqualToString:@"April"]) {
        selmonth = @"04";
    }
    else if ([month isEqualToString:@"May"]) {
        selmonth = @"05";
    }
    else if ([month isEqualToString:@"June"]) {
        selmonth = @"06";
    }
    else if ([month isEqualToString:@"July"]) {
        selmonth = @"07";
    }
    else if ([month isEqualToString:@"August"]) {
        selmonth = @"08";
    }
    else if ([month isEqualToString:@"September"]) {
        selmonth = @"09";
    }
    else if ([month isEqualToString:@"October"]) {
        selmonth = @"10";
    }
    else if ([month isEqualToString:@"November"]) {
        selmonth = @"11";
    }
    else if ([month isEqualToString:@"December"]) {
        selmonth = @"12";
    }
    
    
    selyear = [NSString stringWithString:[year objectAtIndex:[expDate selectedRowInComponent:1]]];
	//NSLog(@"%@,%@",[activities objectAtIndex:[pickerView selectedRowInComponent:0]],[feeling objectAtIndex:[pickerView selectedRowInComponent:1]]);
    NSLog(@"yesr %@",selyear);
    NSLog(@"yesr %@",selmonth);
    
	[dateVallue setTitle:msg forState:0];
    expDate = false;
    [doneButton setHidden:true];
	// grow the table back again in vertical size to make room for the date picker
	//	CGRect newFrame = self.tableView.frame;
	//	newFrame.size.height += self.tempPickerView.frame.size.height;
	//	self.tableView.frame = newFrame;
	
	// remove the "Done" button in the nav bar
	//self.navigationItem.rightBarButtonItem = nil;
    
    
    
    
}

- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
								   screenRect.size.height - size.height,
								   size.width,
								   size.height);
	return pickerRect;
}


-(IBAction)showdatepickerview:(id)sender{
    /*if (cardType) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please tap done to remove picker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{*/
        [doneButton setHidden:false];
        
        //doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)]; 
        // Make temperature picker
        expDate = [[UIPickerView alloc] initWithFrame:CGRectZero];
        CGSize pickerSize = [expDate sizeThatFits:CGSizeZero];
        expDate.frame = [self pickerFrameWithSize:pickerSize] ;
        
        expDate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        expDate.showsSelectionIndicator = YES;
        
        // this view controller is the data source and delegate
        expDate.delegate = self;
        expDate.dataSource = self;
        
        //self.navigationItem.rightBarButtonItem = doneButton;	// Add Done button to handle when choice is done
        // Ensure that the tag value gets forwarded to the action handler
        
        // Check if temperature picker is already on screen. If so, skip creating picker view and go to handling choice
        if (self.expDate.superview == nil)
        {
            // Add the picker
            [self.view.window addSubview: self.expDate];
            
            // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
            //
            // compute the start frame
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGSize pickerSize = [self.expDate sizeThatFits:CGSizeZero];
            CGRect startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, pickerSize.width, pickerSize.height);
            self.expDate.frame = startRect;
            
            // compute the end frame
            CGRect pickerRect = CGRectMake(0.0,screenRect.origin.y + screenRect.size.height - pickerSize.height,pickerSize.width, pickerSize.height);
            
            // start the slide up animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:PICKER_ANIMATION_DURATION];
            [UIView setAnimationDelay:PICKER_ANIMATION_DELAY];			// Give time for the table to scroll before animating the picker's appearance
            
            // we need to perform some post operations after the animation is complete
            [UIView setAnimationDelegate:self];
            
            self.expDate.frame = pickerRect;
            
            
            // shrink the table vertical size to make room for the date picker
            //			CGRect newFrame = appDelegate.setPointController.view.frame;
            //			newFrame.size.height -= self.tempPickerView.frame.size.height;
            //			appDelegate.setPointController.view.frame = newFrame;
            [UIView commitAnimations];
            //[textField resignFirstResponder];
            
        //}
    }
    
}
/*-(IBAction)showcardpickerview:(id)sender
{
    
    if (expDate) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please tap done to remove picker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        
        [doneCardTypeButton setHidden:false];
        //doneCardTypeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneCardAction:)]; 
        // Make temperature picker
        cardType = [[UIPickerView alloc] initWithFrame:CGRectZero];
        CGSize pickerSize = [cardType sizeThatFits:CGSizeZero];
        cardType.frame = [self pickerFrameWithSize:pickerSize] ;
        
        cardType.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        cardType.showsSelectionIndicator = YES;
        
        // this view controller is the data source and delegate
        cardType.delegate = self;
        cardType.dataSource = self;
        
        //self.navigationItem.rightBarButtonItem = doneCardTypeButton;	// Add Done button to handle when choice is done
    	// Ensure that the tag value gets forwarded to the action handler
        
        // Check if temperature picker is already on screen. If so, skip creating picker view and go to handling choice
        if (self.cardType.superview == nil)
        {
            // Add the picker
            [self.view.window addSubview: self.cardType];
            
            // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
            //
            // compute the start frame
            CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
            CGSize pickerSize = [self.cardType sizeThatFits:CGSizeZero];
            CGRect startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, pickerSize.width, pickerSize.height);
            self.cardType.frame = startRect;
            
            // compute the end frame
            CGRect pickerRect = CGRectMake(0.0,screenRect.origin.y + screenRect.size.height - pickerSize.height,pickerSize.width, pickerSize.height);
            
            // start the slide up animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:PICKER_ANIMATION_DURATION];
            [UIView setAnimationDelay:PICKER_ANIMATION_DELAY];			// Give time for the table to scroll before animating the picker's appearance
            
            // we need to perform some post operations after the animation is complete
            [UIView setAnimationDelegate:self];
            
            self.cardType.frame = pickerRect;
            
            
            // shrink the table vertical size to make room for the date picker
            //			CGRect newFrame = appDelegate.setPointController.view.frame;
            //			newFrame.size.height -= self.tempPickerView.frame.size.height;
            //			appDelegate.setPointController.view.frame = newFrame;
            [UIView commitAnimations];
            //[textField resignFirstResponder];
            
        }
        
    }
}
*/



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.responseData = nil;
    //NSLog(@"stringssss          %@      ",responseString);
    // Create a dictionary from the JSON string
    NSLog(@"shibu");
    
   // NSMutableArray *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    

    if(tempidentity == 9){
        
        NSString *dates = [[NSString alloc]initWithFormat:@"%@-%@-27",selyear,selmonth];
        NSString *string = [[NSString alloc] initWithFormat:@"Credit Card"];
        NSString *str = [NSString stringWithFormat:@"%@android_insert.php?table_name=donor_payment_methods&cc_name_on_card=%@&cc_no=%@&credit_card_type_id=%@&paymet_mode=%@&session_id=%@&cc_card_expiry_month=%@&cc_card_expiry_year=%@&cc_card_expiry_date=%@&amount=%@&event_id=%@",[[standardUserDefault objectForKey:@"urlstring"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[name.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[creditCardNo.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[cardVallue.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefault objectForKey:@"sessionid"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[selmonth stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[selyear stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[dates stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[amount.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefault objectForKey:@"eventid"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        //NSString *str = [NSString stringWithFormat:@"%@android_insert.php?table_name=donor_payment_methods&cc_name_on_card=%@&cc_no=%@&cvv_no=%@&address=%@&city=%@&state=%@&zip=%@&credit_card_type_id=%@&paymet_mode=%@&session_id=%@&cc_card_expiry_month=%@&cc_card_expiry_year=%@&cc_card_expiry_date=%@&amount=%@&event_id=%@&email_id=%@",[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[name.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[creditCardNo.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[cvvNo.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[streetAdd.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[city.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[stateVallue.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[zip.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[cardVallue.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[session_id stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[selmonth stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[selyear stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[dates stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefaults objectForKey:@"demoamount"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[eventid stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefaults objectForKey:@"demoemail"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        
        tempidentity = 3;
        NSLog(@"my Url %@",str);
        NSURLRequest *urls = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
        NSLog(@"my Url %@",urls);
        [[NSURLConnection alloc] initWithRequest:urls delegate:self];
    }
    
    else if(tempidentity == 3){
        
        NSRange titleResultsRange = [responseString rangeOfString:@"fail" options:NSCaseInsensitiveSearch];
		NSLog(@"stemp %@",responseString);
        //NSRange titleResultsRange = [responseString rangeOfString:@"fail" options:NSCaseInsensitiveSearch];
        if (titleResultsRange.length > 0){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your payment could nt be processed. An email with transaction details has been sent to you." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message: @"Thanks you for your contribution. An email of your payment status will be sent to you." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
           
            
        }
    }
    
    NSLog(@"%@",creditCardNo.text);
    
    NSLog(@"%@",cvvNo.text);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    NSLog(@"index %@",alertView.title);
    if (alertView.numberOfButtons == 2) {
        
        if (buttonIndex == 0)
        {
            paymentinfoViewController *PaymentInfoViewController = [[paymentinfoViewController alloc] initWithNibName:@"paymentinfoViewController" bundle:nil];
            [self.navigationController pushViewController:PaymentInfoViewController animated:YES];
            
        }
        else if (buttonIndex == -1) {
            
        }
    }
}




-(void)approve:(id)sender{
    
    // NSString *ccnoRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    //NSString *nameRegEx = @"[A-Za-z0-9._%+-]{2,25}";
    NSString *creditCardnoRegEx = @"[0-9]{16}";
    //NSString *cvvnoRegEx = @"[0-9]{3,4}";
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSString *phoneRegEx = @"[0-9]{10}"; 
    NSString *amountRegEx = @"[0-9.]{2,7}";
    NSString *cctypeRegEx = @"[A-Za-z ]{16}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSPredicate *cctypeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cctypeRegEx];
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegEx];
    NSPredicate *amountTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", amountRegEx];
    //NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegEx];
    NSPredicate *creditCardnoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", creditCardnoRegEx];
    //NSPredicate *cvvnoTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cvvnoRegEx];
    
    
    //NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipRegEx];
    //NSPredicate *straddTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", straddRegEx];
    
    //Valid email address 
    
    if([name.text isEqualToString: @""]||[email.text isEqualToString:@""]||[creditCardNo.text isEqualToString:@""]||[phone.text isEqualToString:@""]||[amount.text isEqualToString:@""]||[ccType.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Fill in All Required Fields." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else /*if ([nameTest evaluateWithObject:name.text] == YES) 
    {
        
        NSLog(@"correct name"); 
        
        //if ([cvvnoTest evaluateWithObject:cvvNo.text] == YES) 
        //{
            
          //  NSLog(@"correct cvv no"); */
            
            if ([creditCardnoTest evaluateWithObject:creditCardNo.text] == YES) 
            {
                
                NSLog(@"correct cc no"); 
                
                
                
                //if ([straddTest evaluateWithObject:streetAdd.text] == YES) 
                //{
                
                
                if ([cctypeTest evaluateWithObject:ccType.text] == YES) 
                {
                    
                    NSLog(@"correct card Type");
                    
                    if ([emailTest evaluateWithObject:email.text] == YES) 
                    {
                        
                        NSLog(@"correct email"); 
                        
                        if ([phoneTest evaluateWithObject:phone.text] == YES) 
                        {
                            
                            NSLog(@"correct phone no"); 
                            
                            
                            if ([amountTest evaluateWithObject:amount.text] == YES) 
                            {
                                
                          
                                
                                NSLog(@"correct amount");
                                
                                
                                if (![dateVallue.titleLabel.text isEqualToString:@"Select Date"]&&![dateVallue.titleLabel.text isEqualToString:@""]) 
                                {
                                    
                                    NSLog(@"correct date"); 
                                    
                                    NSString *str = [NSString stringWithFormat:@"%@android_insert.php?table_name=donor_events&name=%@&amount=%@&session_id=%@&email_id=%@&phone=%@&event_id=%@&location_id=%@&payment_frequency=One-Time",[[standardUserDefault objectForKey:@"urlstring"]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[name.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[amount.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefault objectForKey:@"sessionid"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[email.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[phone.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefault objectForKey:@"eventid"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],[[standardUserDefault objectForKey:@"location_id"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
                                    NSLog(@"my Url %@",str);
                                    
                                    tempidentity = 9;
                                    NSURLRequest *urls = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
                                    // NSLog(@)
                                    //creditCardController.identity = identity;
                                    
                                    NSLog(@"my URL %@",urls);
                                    [[NSURLConnection alloc] initWithRequest:urls delegate:self];
                                }
                                else
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                                    [alert show];
                                    NSLog(@"incorrect date");
                                }
                                
                                
                            }
                            
                            else
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter valid amount" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"incorrectname");
                            } 
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter valid phone no" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            NSLog(@"incorrectname");
                        }  
                    }
                    else
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter valid email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        NSLog(@"incorrectname");
                    }                     
                    
                }
                
                
                
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please select Card Type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                    NSLog(@"incorrect card type");
                }
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter valid cc no" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
                NSLog(@"incorrect cc no");
            }

        /*}
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter valid cvv no" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            NSLog(@"incorrect cvv no");
        }*/
    //}
    /*else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Enter proper name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        NSLog(@"incorrect Name");
    }  */
}










- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    keyboardVisible =NO;
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have Successfully swiped the card" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //[alert show];
    
    mAudioLib.OnDevicePluggedIn = @selector(OnDevicePluggedIn);
    [mAudioLib StartDevice];
    [mAudioLib WaitForSwipe:90];
    mAudioLib.OnNoDevicePluggedIn = @selector(OnNoDevicePluggedIn);
    [super viewWillAppear:animated];
    
    NSLog(@"view will apppppppperwar ");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    keyboardVisible =NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    
    //[mAudioLib OnInterrupted];
    //[mAudioLib StopDevice];
    //[mAudioLib dealloc];
    //[mAudioLib release];
    //[AudioAnalyLib release];
    NSLog(@"view will disapppppppperwar");
    if (expDate) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please tap done to remove picker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSLog(@"unload view");
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == expDate) {
        return 2;
    }
    else{
        return 1;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	/*if(pickerView == cardType ){
        if (expDate) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please tap done to remove picker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
		return [ccType count];
	}
    else */
    if(pickerView == expDate ){
        /*if (cardType) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please tap done to remove picker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }*/
        if (component==0)
        {
            return [months count];
        }
        else if (component==1)
        {
            return[year count];
        }
        
        
        
    }
    
}
#pragma mark Picker Delegate Methods




- (UIView *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    /*if(pickerView == cardType ){
		return [ccType objectAtIndex:row];
	}
    else*/ if(pickerView == expDate ){
		switch (component) 
        {
            case 0:
                return [months objectAtIndex:row];
                break;
            case 1:
                return [year objectAtIndex:row];
                break;
        }
        return nil;
        
	}        
	
}


-(void)keyboardDidShow:(NSNotification *)notif{
    
    if (expDate) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please tap done to remove picker" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSLog(@"recieved UIKeyboardDidShowNotification");
        if (keyboardVisible) {
            NSLog(@"keyboard allready visible");
            return;
        }
        CGRect keyboardFrame;
        NSDictionary* userInfo = notif.userInfo;
        keyboardSlideDuration = [[userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey] floatValue];
        keyboardFrame = [[userInfo objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        
        UIInterfaceOrientation theStatusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        if UIInterfaceOrientationIsLandscape(theStatusBarOrientation)
            keyboardShiftAmount = keyboardFrame.size.width;
        else 
            keyboardShiftAmount = keyboardFrame.size.height;
        
        [UIView beginAnimations: @"" context: nil];
        [UIView setAnimationDuration: keyboardSlideDuration];
        [UIView commitAnimations];
        
        viewShiftedForKeyboard = TRUE;
        
    }
}

-(void)keyboardDidHide:(NSNotification *)notif{
    
    NSLog(@"recieved UIKeyboardDidHideNotification");
    
    if (keyboardVisible) {
        NSLog(@"keyboard  visible");
        return;
    }
    
    if (!viewShiftedForKeyboard)
    {
        [UIView beginAnimations: @"ShiftUp" context: nil];
        [UIView setAnimationDuration: keyboardSlideDuration];
        [self resignFirstResponder];
        
        //self.view.center = CGPointMake( self.view.center.x, self.view.center.y + keyboardShiftAmount);
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height -= keyboardShiftAmount;
        scrollView.frame = viewFrame;
        [UIView commitAnimations];
        viewShiftedForKeyboard = FALSE;
        keyboardVisible = NO;
    }
    
    
    
    /*[self resignFirstResponder];
     NSDictionary *innfo = [notif userInfo];
     NSValue *avalue = [innfo objectForKey:UIKeyboardBoundsUserInfoKey];
     CGSize keyboardSize = [avalue CGRectValue].size;
     CGRect viewFrame = self.view.frame;
     viewFrame.size.height += keyboardSize.height;
     scrollView.frame = viewFrame;
     
     keyboardVisible = NO;*/
}





- (void)viewDidUnload
{
    [standardUserDefault removeObjectForKey:@"location_id"];
    [standardUserDefault removeObjectForKey:@"eventid"];
    [standardUserDefault removeObjectForKey:@"eventtitle"];
    [standardUserDefault removeObjectForKey:@"ccno"];  
    [standardUserDefault removeObjectForKey:@"name"];
    [standardUserDefault removeObjectForKey:@"date"];    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/*[creditCardNo setText:[standardUserDefault objectForKey:@"ccno"]];
[name setText:[standardUserDefault objectForKey:@"name"]];

[dateVallue setTitle:[standardUserDefault objectForKey:@"date"] forState:0];*/

@end