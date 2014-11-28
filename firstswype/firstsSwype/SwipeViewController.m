//
//  SwipeViewController.m
//  firstsSwype
//
//  Created by My Work Force on 09/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
#import "SwipeViewController.h"
#import "eventViewController.h"
#import "PaymentDetailViewController.h"
#import "AudioAnalyData.h"
#import "DUKPT_DES.h"
#import "String.h"


static unsigned char  MainKey[16],NowKey[16],RealOutData[500];


@implementation SwipeViewController

@synthesize date,nam,ccno,standardUserDefault;

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
            /*tempString = [NSString stringWithCString:(const char *)RealOutData encoding:NSUTF8StringEncoding];// decoded card data 
            
            //NSString *string2;
            
            ccno = [tempString substringWithRange: NSMakeRange (2, 16)];
            
            NSLog (@"string2 = %@", ccno);
            NSLog(@"OnSwipeCompletedgdfskjnbvkjjdhsfbkvjhdkjzbnv %@",tempString);
            NSArray *myArray = [tempString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
            NSLog(@"%@",[myArray objectAtIndex:0]);
            NSLog(@"%@",[myArray objectAtIndex:1]);
            NSString *str = [[NSString alloc] initWithString:[[myArray objectAtIndex:1] substringWithRange: NSMakeRange (1, 4)]];
            date = [[NSString alloc] initWithFormat:@"20%@/%@",[str  substringWithRange: NSMakeRange (0, 2)],[str substringWithRange: NSMakeRange (2, 2)]];
            NSArray *myArray1 = [[myArray objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"^"]];
            NSLog(@"%@",[myArray1 objectAtIndex:0]);
            NSLog(@"%@",[myArray1 objectAtIndex:1]);
            nam = [myArray1 objectAtIndex:1];
            NSArray *myArray2 = [[myArray1 objectAtIndex:1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
            NSLog(@"%@",[myArray2 objectAtIndex:0]);
            NSLog(@"%@",[myArray2 objectAtIndex:1]);
            *strout = [*strout stringByAppendingFormat:@"[Encrypt Data:] %s\n[Card Data:]\n %@ \n[CardNumber:]  %s \n[First6cardNum:]  %s  [Last4cardNum:]  %s\n[Name:]  %s \n[ExpireDate:]  %s     [ServiceCode:]  %s \n [KSN:]  %s [CheckSum:]  %s\n ",EncryptData,tempString,CardNumber,First6cardNum,Last4cardNum,Name,ExpireDate,ServiceCode,KSN,CheckSum];
            //ccno = [NSString stringWithFormat:@"%s",(NSString *)CardNumber];
            //nam = [NSString stringWithFormat:@"%s",Name];
            //date = [NSString stringWithFormat:@"%s",ExpireDate];
            
            //[mAudioLib.delegate release];
            NSLog(@"OnSwipeCompleted %@",date);
            NSLog(@"OnSwipeCompleted %@",nam);
            NSLog(@"OnSwipeCompleted %@",ccno);
            standardUserDefault = [NSUserDefaults alloc];
            [standardUserDefault setObject:ccno forKey:@"ccno"];
            [standardUserDefault setObject:nam forKey:@"name"];
            [standardUserDefault setObject:date forKey:@"date"];
            
            //[alert dismissWithClickedButtonIndex:-1 animated:YES];
            
        
        }
        else{
            printf("CheckSum ERROR");
            
            // to do what you want to do here
            return;
        }
        
    }else
        return;
    
    
}

-(void)Change:(id)sender
{
    PaymentDetailViewController *pdvc = [[PaymentDetailViewController alloc] initWithNibName:@"PaymentDetailViewController" bundle:nil];
       [self.navigationController pushViewController:pdvc animated:YES];
}

-(void)test:(UIAlertView*)x{
    [x dismissWithClickedButtonIndex:-1 animated:YES];
}


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




/*
 - (void)ShowTextView:(NSString *)text {
 //NSString *tmp = [NSString stringWithFormat:@"%s", szRecvBuf];
 //if (!mTextView.text) {
 mTextView.text = @"";
 NSLog(@"hgfhgfhgfhg %@",text);
 //sleep(1);
 //}
 
 if (text) {
 mTextView.text = [NSString stringWithFormat:@"\r\n%@", text];//stringByAppendingFormat
 }else
 mTextView.text = [NSString stringWithFormat:@"\r\n%s", szRecvBuf];
 
 
 }*/
/*
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




- (void)viewDidLoad
{
    standardUserDefault = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefault objectForKey:@"swipe"]==@"yes") {
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
    }
    
	
	

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
/*
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
   /* [mAudioLib WaitForSwipe:20];
}

- (void)OnInterrupted {
    NSLog(@"OnInterrupted");
}





- (void)viewDidUnload
{
        [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)viewWillAppear:(BOOL)animated{
    mAudioLib.OnDevicePluggedIn = @selector(OnDevicePluggedIn);
    [mAudioLib StartDevice];
    [mAudioLib WaitForSwipe:90];
    mAudioLib.OnNoDevicePluggedIn = @selector(OnNoDevicePluggedIn);
    
    [super viewWillAppear:animated];
    
    
    NSLog(@"view will apppppppperwar ");
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [mAudioLib OnInterrupted];
    //[mAudioLib StopDevice];
    //[mAudioLib dealloc];
    //[mAudioLib release];
    //[AudioAnalyLib release];
    

    NSLog(@"view will disapppppppperwar");
    NSLog(@"unload view");
}



@end*/
