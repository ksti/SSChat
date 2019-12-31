//
//  NIMNetCallBypassTaskConfig.h
//  NIMAVChat
//
//  Created by Simon Blue on 2019/9/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NIMNetCallBypassTaskConfig : NSObject

/**
 推流任务Id
 */
@property (nonatomic, copy)NSString *taskId;

/**
 互动直播推流地址
 */
@property (nonatomic, copy)NSString *streamingUrl;

/**
 *  互动直播音视频混屏模式，在 NIMNetCallBypass StreamingMixMode 里面选择合适的模式
 */
@property (nonatomic, assign)NSInteger streamingLayoutMode;

/**
 *  互动直播音视频混屏自定义布局配置，在 bypassStreamingMixMode 为 NIMNetCallBypassStreamingMixModeCustomVideoLayout 或 NIMNetCallBypassStreamingMixModeCustomAudioLayout 时必须设置
 */
@property (nonatomic, copy)NSString *streaminglayoutConfig;

/**
 互动直播服务器录制，互动直播服务器录制功能需要开通才能使用）
 */
@property (nonatomic, assign)BOOL serverRecord;

/**
 要设置主画面的accid，可以不指定
 */
@property (nonatomic, copy)NSString *accid;

@end

NS_ASSUME_NONNULL_END
