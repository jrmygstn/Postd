//
//  videoView.swift
//  Postd
//
//  Created by Jeremy Gaston on 12/13/17.
//  Copyright © 2017 KeepUsPostd. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

private var playbackLikelyToKeepUpContext = 0

class videoView: UIViewController {
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    let invisibleButton = UIButton()
    var timeObserver: AnyObject!
    let timeRemainingLabel = UILabel()
    let seekSlider = UISlider()
    var playerRateBeforeSeek: Float = 0
    let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(invisibleButton)
        invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped),
                                  for: .touchUpInside)
        
        // An AVPlayerLayer is a CALayer instance to which the AVPlayer can
        // direct its visual output. Without it, the user will see nothing.
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        let url = NSURL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")
        let playerItem = AVPlayerItem(url: url! as URL)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
                                                                    
            // print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
            self.observeTime(elapsedTime: elapsedTime)
            } as AnyObject
        
        timeRemainingLabel.textColor = .white
        view.addSubview(timeRemainingLabel)
        
        view.addSubview(seekSlider)
        seekSlider.addTarget(self, action: #selector(sliderBeganTracking),
                             for: .touchDown)
        seekSlider.addTarget(self, action: #selector(sliderEndedTracking),
                             for: [.touchUpInside, .touchUpOutside])
        seekSlider.addTarget(self, action: #selector(sliderValueChanged),
                             for: .valueChanged)
        
        loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(loadingIndicatorView)
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                             options: .new, context: &playbackLikelyToKeepUpContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &playbackLikelyToKeepUpContext {
            if avPlayer.currentItem!.isPlaybackLikelyToKeepUp {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    deinit {
        avPlayer.removeTimeObserver(timeObserver)
        avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.startAnimating()
        avPlayer.play() // Start the playback
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Layout subviews manually
        avPlayerLayer.frame = view.bounds
        invisibleButton.frame = view.bounds
        
        let controlsHeight: CGFloat = 30
        let controlsY: CGFloat = view.bounds.size.height - controlsHeight
        timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
        
        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width, y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
        loadingIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    @objc func sliderBeganTracking(slider: UISlider) {
        playerRateBeforeSeek = avPlayer.rate
        avPlayer.pause()
    }
    
    @objc func sliderEndedTracking(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
        
        avPlayer.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
            if self.playerRateBeforeSeek > 0 {
                self.avPlayer.play()
            }
        }
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
//        if isfinite(duration) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
//        }
    }
    
    @objc func invisibleButtonTapped(sender: UIButton) {
        let playerIsPlaying = avPlayer.rate > 0
        if playerIsPlaying {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
    
    // Force the view into landscape mode (which is how most video media is consumed.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}
