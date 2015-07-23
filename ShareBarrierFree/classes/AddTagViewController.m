//
//  AddTagViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-12.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "AddTagViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ProgressHUD.h"
#import "GVUserDefaults+Properties.h"
#import "ShareBarrierFreeAPIS.h"
@interface AddTagViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>{
    BMKPointAnnotation* pointAnnotation;
}

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }

    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveNewTag)];
    //initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewTag)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    [mapView setZoomLevel:18];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self addPointAnnotation];
}

-(void)viewWillAppear:(BOOL)animated{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

}

-(void)viewWillDisappear:(BOOL)animated{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (mapView) {
        mapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)uploadPictureBtn:(id)sender {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];

}

- (IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageView setImage:portraitImg];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - add PointAnnotation
-(void) addPointAnnotation{
    
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = _pt;
    pointAnnotation.title = @"长按拖拽到设施位置";
    [mapView addAnnotation:pointAnnotation];
    [mapView setNeedsDisplay];

    mapView.centerCoordinate = _pt;
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"moveAnnotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
        // 设置是否可以拖拽
        [((BMKPinAnnotationView*)annotationView) setDraggable:YES];
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    [annotationView setSelected:YES animated:YES];

    return annotationView;
}

/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    if (newState == BMKAnnotationViewDragStateEnding) {
        NSLog(@"%f,%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
        _pt = view.annotation.coordinate;
    }
}

/**
 *点中底图空白处会回调此接口
 *@param mapview 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self.view endEditing:YES];
}


#pragma mark - picture compress
-(NSString*) compressPicture{
    NSData *imageData = UIImageJPEGRepresentation(imageView.image,0.001);
   //NSLog(@"%@",imageData);
    //UIImage *resultImage = [UIImage imageWithData:imageData];
    NSString *str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return str;
}

-(void)saveNewTag{
    //NSLog(@"success saved %f,%f,%@",_pt.latitude,_pt.longitude,describeText.text);
//    NSData *imageData = [self compressPicture];
//    NSString *tagDescribe = [NSString stringWithFormat:@"%@",describeText.text];
    [ProgressHUD show:@"正在上传"];
    self.view.userInteractionEnabled = false;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //获取当前时间
    NSDate *  sendDate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
    NSString *  dateString=[dateformatter stringFromDate:sendDate];
    
    [dic setObject:titleText.text forKey:@"title"];
    [dic setObject:detailDescrption.text forKey:@"description"];
    [dic setObject:dateString forKey:@"time"];
    [dic setObject:[NSNumber numberWithInteger:[GVUserDefaults standardUserDefaults].userId] forKey:@"user_id"];
    
    double longtitude = pointAnnotation.coordinate.longitude;
    double latitude = pointAnnotation.coordinate.latitude;
//    if (longtitude > 0) {
//        [dic setObject:@"E" forKey:@"longitude_index"];
//    }else{
//        [dic setObject:@"W" forKey:@"longitude_index"];
//    }
//    if (latitude > 0) {
//        [dic setObject:@"N" forKey:@"latitude_index"];
//    }else{
//        [dic setObject:@"S" forKey:@"latitude_index"];
//    }
    [dic setObject:[NSNumber numberWithDouble:longtitude] forKey:@"longitude"];
    [dic setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    
    [dic setObject:[self compressPicture] forKey:@"picture"];
    
    dispatch_async(serverQueue, ^{
        NSDictionary *resultDic = [ShareBarrierFreeAPIS UploadOneTag:dic];
        if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"发布成功" waitUntilDone:YES];
            
        }else
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"发布失败" waitUntilDone:YES];
            return ;
        }
    });

}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
//{
//    _pt = newCoordinate;
//    NSLog(@"DDd");
//}
@end
