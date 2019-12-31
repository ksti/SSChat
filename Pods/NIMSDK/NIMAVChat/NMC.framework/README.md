## profiles.h
主要接口

```cpp
namespace profiles {
    class Profiles {
    public:
        /** 
         * @brief 初始化模块
         * @param release    true=空实现，false=有日志输出
         * @param platform   能力提供类，需要各个平台做实现，std::make_shared<profiles::ProfilesPlatformAndroidImpl>()
         */
        static void Init(bool release, std::shared_ptr<ProfilesPlatform> platform);
        /** 
         * @brief 开始打点采集、日志输出线程
         */
        static void Start();
         /** 
         * @brief 结束打点采集、日志输出线程
         */
        static void Stop();

        /** 
         * @brief 统计打点开始
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，可能为uid, ssrc等值，会影响聚合，会影响tag
         * @param order     统计点在相同type中的顺序，只会影响输出显示
         *
         * @return token    统计点唯一id，用于结束打点Profiles#End方法
         */
        static const std::string Begin(const char* module, const char* tag, const char* type, int32_t order);
         /** 
         * @brief 支持跨线程的统计打点开始
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，0为主流程，1为次流程，只会影响输出显示
         * @param order     统计点在相同type中的顺序，只会影响输出显示
         *
         * @return token    统计点唯一id，用于结束打点Profiles#End方法
         */
        static const std::string BeginMultiThread(const char* module, const char* tag, const char* type, int32_t order);
         /** 
         * @brief 统计打点结束
         * @param token     使用token结束打点
         */
        static void End(const char* token);
        /** 
         * @brief 帧统计打点开始
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，可能为uid, ssrc等值，会影响聚合，会影响tag
         * @param frameId        帧id，需要在相同module+tag内唯一
         * @param order     统计点在相同type中的顺序，只会影响输出显示
         */
        static void BeginWithId(const char* module, const char* tag, const char* type, const char* frameId, int32_t order);
        /** 
         * @brief 帧统计打点结束
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，可能为uid, ssrc等值，会影响聚合，会影响tag
         * @param frameId        帧id，需要在相同module+tag内唯一
         */
        static void EndWithId(const char* module, const char* tag, const char* type, const char* frameId);
        /** 
         * @brief 函数调用间隔统计
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，0为主流程，1为次流程，只会影响输出显示
         * @param order     统计点在相同type中的顺序，只会影响输出显示
         */
        static void Duration(const char* module, const char* tag, const char* type, int32_t order);
        /** 
         * @brief 直接传cost（单位ms），适用于引擎的那2个回调
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，可能为uid, ssrc等值，会影响聚合，会影响tag
         * @param cost      消耗时间，单位ms
         * @param order     统计点在相同type中的顺序，只会影响输出显示
         */
        static void Cost(const char* module, const char* tag, const char* type, int64_t cost, int32_t order);
        /**
         * @brief 抖动计算 会统计最大值 最小值 方差 均值
         * @param module    模块名
         * @param tag       统计点名称
         * @param type      统计点类型，可能为uid, ssrc等值，会影响聚合，会影响tag
         * @param value      消耗时间，单位ms
         * @param order     统计点在相同type中的顺序，只会影响输出显示
         */
        static void Jitter(const char* module, const char* tag, const char* type, int64_t value, int32_t order);
    };
}
```

## profiles_platform.h
各平台实现接口

```cpp
namespace profiles {
    class ProfilesPlatform {
    public:
        // to impl
        virtual ~ProfilesPlatform() {}
        /** 
         * @brief 打印日志
         * @param log       日志内容
         */
        virtual void ProfilesLog(const char* log) = 0;
        /** 
         * @brief cpu使用率
         * @return cpu      cpu使用率 如0.99
         */
        virtual float ProfilesGetCpu() = 0;
        /** 
         * @brief cpu频率
         * @return cpu频率     cpu频率，单位赫兹
         */
        virtual int64_t ProfilesGetCpuFreq() = 0;
        /**
        * @brief cpu内核个数
        * @return cpu内核个数 如6
        */
        virtual int32_t ProfilesGetCpuCoreCnt() = 0;
        /** 
         * @brief 电量
         * @return 电池电量     电量满格1为，如0.99
         */
        virtual float ProfilesGetBattery() = 0;
        /** 
         * @brief 温度
         * @return 温度     单位摄氏度，如37
         */
        virtual int32_t ProfilesGetTemperature() = 0;
        /** 
         * @brief 内存使用大小
         * @return 内存使用大小     单位KB
         */
        virtual int32_t ProfilesGetMemoryUsage() = 0;
        /** 
         * @brief 通话唯一标识
         * @return 通话唯一标识
         */
        virtual const std::string ProfilesGetSessionId() = 0;
        /** 
         * @brief 通话信息
         * @return 如720x480 15FPS 6P，会作为辅助信息显示，可以自定义内容和格式
         */
        virtual const std::string ProfilesGetSessionInfo() = 0;

        /**
         * @brief 各线程cpu占用
         * @return 线程名,占用,线程名,占用，用英文逗号分隔，如 nrtc_video_x,0.10,nrtc_video_send,0.2
         */
        virtual const std::string ProfilesGetCpuThread() = 0;

        /**
        * @brief 网络状态
        * @return uid,rtt,videolossrate,uid,rtt,videolossrate，用英文逗号分隔
        */
        virtual const std::string ProfilesGetNetStatus() = 0;
    };
}

```