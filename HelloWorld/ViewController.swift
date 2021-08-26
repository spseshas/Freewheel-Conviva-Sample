//
//  ViewController.swift
//  HelloWorld
//
//  Created by Prashanth Seshasayee on 1/6/21.
//

import UIKit
import AVKit
import AVFoundation
import ConvivaSDK

class ViewController: UIViewController
{
    @IBOutlet weak var playerContainerView: UIView!
    var avPlayerViewController : AVPlayerViewController!
    var avPlayer : AVPlayer!
    
    var analytics: CISAnalytics!
    var videoAnalytics: CISVideoAnalytics!
    var contentInfo = [String:Any]()
    
    var adManager:FWAdManager!
    var adContext:FWContext!
    var adRequestConfiguration:FWRequestConfiguration!
    
    var flag = false
    var requestCompleted = false
    
    var timeObserverToken: Any?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        InitAll()
    }
    
    func InitAll()
    {
        setPlayerInfo()
        initAdManager()
        initConvivaLib()
    }
    
    func setPlayerInfo()
    {
        let videoURL = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
        avPlayer = AVPlayer(url: videoURL!)
        avPlayerViewController = AVPlayerViewController()
        
        avPlayerViewController.player = avPlayer
        
        view.addSubview(avPlayerViewController.view)
        avPlayerViewController.view.frame = playerContainerView.frame
//        avPlayerViewController.allowsPictureInPicturePlayback = true
        
    }
    
    func initAdManager()
    {
        print("\n\n INIT ADS \n\n")
        adManager = newAdManager()
        adManager.setNetworkId(96749)
        adManager.setCurrentViewController(self)
        
        adContext = adManager.newContext()
        adContext.setVideoDisplayBase(avPlayerViewController.view)
        adContext.setParameter(FWParameterNonTemporalSlotVisibilityAutoTracking, withValue: "YES", for: FWParameterLevel.override)
        
        configAdRequest("http://cue.v.fwmrm.net", playerProfile: "96749:global-cocoa")
        setSiteSection("DemoSiteGroup.01")
        setVideoAsset("DemoVideoGroup.01", duration: 500)
        addValue("JSAMDemoPlayer", forKey: "customTargetingKey")
        addPrerollSlot("pre1")
    }
    
    func initConvivaLib()
    {
        let TEST_CUSTOMER_KEY = "1a6d7f0de15335c201e8e9acabc7a0952f5191d7"
        let TOUCHSTONE_SERVICE_URL = "https://dryrun.testonly.conviva.com"
        analytics = CISAnalyticsCreator.create(withCustomerKey: TEST_CUSTOMER_KEY , settings: [CIS_SSDK_SETTINGS_GATEWAY_URL: TOUCHSTONE_SERVICE_URL, CIS_SSDK_SETTINGS_LOG_LEVEL: LogLevel.LOGLEVEL_WARNING.rawValue])!
        videoAnalytics = analytics.createVideoAnalytics()
        
        flag = true
    }
    
    @IBAction func startPlayback(sender: UIButton)
    {
        playVideo()
    }

    @IBAction func stopPlayback(sender: UIButton)
    {
        videoAnalytics!.reportPlaybackEnded()
        videoAnalytics!.cleanup()
        videoAnalytics = nil
        
        avPlayer?.rate = 0.0
        avPlayerViewController?.view.removeFromSuperview()
        avPlayer = nil
        
        flag = false
    }
    
    func playVideo()
    {
        if flag == false
        {
            InitAll()
        }
        loadAds()
        
        getContentInfo()
        videoAnalytics.setContentInfo(contentInfo)
        videoAnalytics.setPlayer(avPlayer!)
        
        videoAnalytics.reportPlaybackRequested(contentInfo)
//        avPlayer.play()
    }
    
    func getContentInfo()
    {
        contentInfo[CIS_SSDK_METADATA_ASSET_NAME] = "The test of tests"
        contentInfo[CIS_SSDK_METADATA_IS_LIVE] = false
        contentInfo[CIS_SSDK_PLAYER_FRAMEWORK_VERSION] = "4.0.5"
        contentInfo[CIS_SSDK_METADATA_PLAYER_NAME] = "AVPLAYER"
        contentInfo[CIS_SSDK_METADATA_VIEWER_ID] = "randomID"
        contentInfo["c3.cm.contentType"] = "Live-Linear"
//        contentInfo["seriesTitle"] = "Val1"
    }
    
    
    /***************************** AD SETTINGS ****************************/
    func setSiteSection(_ siteSectionCustomId:String?)
    {
        if (siteSectionCustomId != nil) {
            let siteSectionConfig:FWSiteSectionConfiguration = FWSiteSectionConfiguration(siteSectionId:siteSectionCustomId!, idType: FWIdType.custom)
            adRequestConfiguration.siteSectionConfiguration = siteSectionConfig
        }
    }
    
    func setVideoAsset(_ videoAssetCustomId:String?, duration:TimeInterval)
    {
        if (videoAssetCustomId != nil) {
            let videoAssetConfig:FWVideoAssetConfiguration = FWVideoAssetConfiguration(videoAssetId: videoAssetCustomId!, idType: FWIdType.custom, duration: duration, durationType: FWVideoAssetDurationType.exact, autoPlayType: FWVideoAssetAutoPlayType.attended)
            adRequestConfiguration.videoAssetConfiguration = videoAssetConfig
        }
    }
    
    func addValue(_ value:String?, forKey key:String?)
    {
        if (value != nil && key != nil) {
            adRequestConfiguration.addValue(value!, forKey: key!)
        }
    }
    
    func configAdRequest(_ serverURL:String?, playerProfile:String?)
    {
        let temp = CGSize(width: 300,height: 300)
        adRequestConfiguration = FWRequestConfiguration.init(serverURL: serverURL!, playerProfile: playerProfile!, playerDimensions: temp)
    }
    
    func addPrerollSlot(_ customId:String)
    {
        if customId != ""
        {
            print("\n\n PREROLL ADDED \n\n")
            let slotConfig:FWTemporalSlotConfiguration = FWTemporalSlotConfiguration(customId: customId, adUnit: FWAdUnitPreroll, timePosition: 0)
            adRequestConfiguration.add(slotConfig);
        }
    }
    
    func loadAds()
    {
        print("\n\n LOAD ADS \n\n")
        NotificationCenter.default.addObserver(self, selector: #selector(onRequestComplete(_:)), name: NSNotification.Name.FWRequestComplete, object: adContext)
        NotificationCenter.default.addObserver(self, selector: #selector(onSlotEnded(_:)), name: NSNotification.Name.FWSlotEnded, object: adContext)
        adContext.submitRequest(with: adRequestConfiguration, timeout: 5)
    }
    
    func notifyVideoState(_ state:FWVideoState)
    {
        adContext.setVideoState(state)
        switch state.rawValue
        {
            case FWVideoState.playing.rawValue:
                avPlayer.play()
            default:
                avPlayer.pause()
        }
    }
    
    @objc func onRequestComplete(_ notification:Notification)
    {
        requestCompleted = true
        print("\n\n REQUEST COMPLETED \n\n")
        var success = false
        if (notification.userInfo as! [String: Any])[FWInfoKeyError] == nil {
            success = true
        }
        
        if (avPlayer != nil)
        {
            let slot:FWSlot = adContext.getSlotsBy(FWTimePositionClass.preroll)[0] as! FWSlot
            
            var adInfo = [AnyHashable : Any]();
            
            adInfo[CIS_SSDK_METADATA_ASSET_NAME] = "adasset";
            adInfo[CIS_SSDK_METADATA_IS_LIVE] = NSNumber(booleanLiteral: true);
            adInfo[CIS_SSDK_METADATA_PLAYER_NAME] = "adplayername";
            adInfo[CIS_SSDK_METADATA_VIEWER_ID] = "viewerid";
            adInfo[CIS_SSDK_METADATA_DEFAULT_RESOURCE] = "resource";
            adInfo[CIS_SSDK_METADATA_DURATION] = NSNumber(integerLiteral: 100);
            adInfo[CIS_SSDK_METADATA_STREAM_URL] = "http://test.m3u8";
            adInfo[CIS_SSDK_PLAYER_FRAMEWORK_NAME] = "frameworkname";
            adInfo[CIS_SSDK_PLAYER_FRAMEWORK_VERSION] = "frameworkversion";
            videoAnalytics.reportAdBreakStarted(AdPlayer.ADPLAYER_CONTENT, adType: AdTechnology.CLIENT_SIDE, adBreakInfo: adInfo)
            (slot).play()
            avPlayer.seek(to: CMTime.zero)
        }
    }
    
    @objc func onSlotEnded(_ notification:Notification)
    {
        let slot:FWSlot = adContext.getSlotByCustomId((notification.userInfo as! [String: Any])[FWInfoKeySlotCustomId] as? String)
        if slot.timePositionClass().rawValue == FWTimePositionClass.preroll.rawValue
        {
            videoAnalytics.reportAdBreakEnded()
            playNextPreroll()
        }
    }
    
    func playNextPreroll()
    {
        //Do something here.
        avPlayer.play()
    }
}

