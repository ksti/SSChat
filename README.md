<div align=center> 
  <img src= "https://raw.githubusercontent.com/Soldoros/SSChat/master/datu/Hello.PNG" width="380"> 
</div>
<br>

<h2>Demo简介</h2>

<span>Hello是基于环信和SSChat框架开发的一款聊天系统，支持在线发送文本、Emojo、图片、动图、音频、视频、位置等。整体功能和界面参照主流的社交软件进行设计，借鉴了微信、QQ、钉钉的一些风格。在此要十分感谢云淡风轻提供的素材，也感谢环信，真的很棒。感谢为此Demo提出宝贵的意见和建议！ </span>


<br>
<span>邮箱：765970680@qq.com  <br>
      钉钉：13540033103 <br>
      简书：https://www.jianshu.com/p/576128ed69e1 </span><br><br><br>

<div align=center> 
  <img src= "https://raw.githubusercontent.com/Soldoros/SSChat/master/datu/1.PNG" width="345"> 
  <img src= "https://raw.githubusercontent.com/Soldoros/SSChat/master/datu/4.PNG" width="345">
</div>


<h2>一、使用键盘</h2>

1.plist文件需要设置权限 https配置 访问相机 麦克风 相册  <br>
```Objective-C

    [App Transport Security Settings -> Allow Arbitrary Loads + YES ]<br>
    [App Transport Security Settings -> Allow Arbitrary Loads in Web Content + YES]<br>
    [Privacy - Camera Usage Description 是否允许此App使用你的相机]<br>
    [Privacy - Location Always and When In Use Usage Description 系统想要访问您的位置]<br>
    [Privacy - Location When In Use Usage Description 系统想要访问您的位置]<br>
    [Privacy - Microphone Usage Description 系统想要访问您的麦克风]<br>
    [Privacy - Photo Library Additions Usage Description 系统需要访问您的相册]<br>
    [Privacy - Photo Library Usage Description 系统需要访问您的相册]<br>

```Objective-C
2.在需要用键盘的控制器引用头文件 #import "SSChatKeyBoardInputView.h" 并设置代理 SSChatKeyBoardInputViewDelegate

3.声明对象来

```Objective-C
//多媒体键盘
@property(nonatomic,strong)SSChatKeyBoardInputView *mInputView;
```
4.初始化多媒体键盘

```Objective-C
_mInputView = [SSChatKeyBoardInputView new];
_mInputView.delegate = self;
[self.view addSubview:_mInputView]; 
```
5.聊天界面通常是一个表单UITableView，这个时候需要在表单点击回调和滚动视图的滚动回调里面对键盘弹出收起做一个简单处理。

```Objective-C
//Keyboard and list view homing
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}

```
7.在键盘的回调方法中，改变输入框高度和键盘位置的方法回调中，需要处理当前表单的frame，具体frame调整需要针对界面的布局来定，这里只对UITableView和它的父视图做个简单调整。

```Objective-C
#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{
 
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, height);
        self.mTableView.frame = self.mBackView.bounds;
        [self updateTableView:YES];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)updateTableView:(BOOL)animation{
    [self.mTableView reloadData];
    if(self.datas.count>0){
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animation];
    }
}

```
8.其它功能根据需求而定，文本消息在跟后台对接时只能使用字符串，布局是需要做图文混排处理，生成富文本。多功能视图简单处理了图片、视频和定位，大家可以自己拓展需要的功能，并在回调方法直接编写逻辑。

```Objective-C
//Send text messages
-(void)SSChatKeyBoardInputViewBtnClick:(NSString *)string;

//Send voice messages
- (void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second;

//Multi-function view button click callback
-(void)SSChatKeyBoardInputViewBtnClickFunction:(NSInteger)index;
```
<br>
<div align=center> 
  <img src= "https://raw.githubusercontent.com/Soldoros/SSChat/master/datu/6.PNG" width="345"> 
  <img src= "https://raw.githubusercontent.com/Soldoros/SSChat/master/datu/10.PNG" width="345">
</div>
<br>

<h2>二、图片和短视频缩放</h2>

1.添加AVFoundation.framework系统库

2.引用头文件#import "SSImageGroupView.h"

3.在点击图片或短视频的时候对图片、短视频的数组做处理，有一些必传的参数

```Objective-C
#pragma SSChatBaseCellDelegate Click on the picture and click on the short video
-(void)SSChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout{
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    
    for(int i=0;i<self.datas.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        SSChatBaseCell *cell = [_mTableView cellForRowAtIndexPath:ip];
        SSChatMessagelLayout *mLayout = self.datas[i];
        
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == SSChatMessageTypeImage){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.image;
        }
        else if(mLayout.message.messageType == SSChatMessageTypeGif){
            item.imageType = SSImageGroupGif;
            item.fromImgView = cell.mImgView;
            item.fromImages = mLayout.message.imageArr;
        }
        else if (mLayout.message.messageType == SSChatMessageTypeVideo){
            item.imageType = SSImageGroupVideo;
            item.videoPath = mLayout.message.videoLocalPath;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.videoImage;
        }
        else continue;
        
        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout])currentIndex = groupItems.count;
        [groupItems addObject:item];
        
    }
    
    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    [self.navigationController.view addSubview:imageGroupView];
    
    __block SSImageGroupView *blockView = imageGroupView;
    blockView.dismissBlock = ^{
        [blockView removeFromSuperview];
        blockView = nil;
    };
    
    //This section is the chat interface keyboard recovery process alone using the media zoom function can not be written
    [self.mInputView SetSSChatKeyBoardInputViewEndEditing];
}
```

<h2>三、直接使用SSChat</h2>

1.引用头文件#import "SSChatController.h"，有一部分的类别大家参考使用，可以改成自己封装的，后期完善后再更新上来。

2.初始化聊天界面，sessionId为会话Id，对接后台时需要传递，这里在做时间5分钟间隔的时候用到了。chatType为会话类型，区分群聊和单聊。群聊和单聊界面相似，后期会更新上来。

```Objective-C
SSChatController *vc = [SSChatController new];
vc.chatType = (SSChatConversationType)[_datas[indexPath.row][@"type"]integerValue];
vc.sessionId = _datas[indexPath.row][@"sectionId"];
vc.titleString = _datas[indexPath.row][@"title"];
[self.navigationController pushViewController:vc animated:YES];

```


