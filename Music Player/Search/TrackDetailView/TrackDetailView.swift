//
//  TrackDetailView.swift
//  Music Player
//
//  Created by Saidaxmad on 30/09/22.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: AnyObject {
    func moveBackForPreviosTrack() -> SearchViewModel.Cell?
    func moveForwardForPreviosTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniLineView: UIView!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniTrackNameLabel: UILabel!
    @IBOutlet weak var miniTrackPauseButton: UIButton!
    @IBOutlet weak var miniTrackGoForwordButton: UIButton!
    
    
    @IBOutlet weak var maximaizedStackView: UIStackView!
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimerSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackImageView.layer.cornerRadius = 20
        miniTrackImageView.layer.cornerRadius = 10
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        trackImageView.clipsToBounds = true
        
        setupGesture()
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        miniTrackNameLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observerPlayerCurrentTime()
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    //        MARK: - Gesture Func setup
    private func setupGesture() {
        
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc private func handleTapMaximized() {
        print("tap maximized")
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            print("default")
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            hanldePanEnded(gesture: gesture)
        case .possible:
            print("no")
        case .cancelled:
            print("no")
        case .failed:
            print("no")
        @unknown default:
            print("default")
        }
    }
    
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximaizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximaizedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                }
            }, completion: nil)
        case .possible:
            print("no")
        case .began:
            print("no")
        case .cancelled:
            print("no")
        case .failed:
            print("no")
        @unknown default:
            print("default")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximaizedStackView.alpha = -translation.y / 200
    }
    
    private func hanldePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if translation.y < -200 || velocity.y < -500 {
                self.transform = .identity
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximaizedStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    private func playTrack(previewUrl: String?) {
        
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    private func monitorStartTime() {
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackView()
        }
    }
    
    private func observerPlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimerSlider.value = Float(percentage)
    }
    
    deinit {
        print("TrackDetail memory being reclaimed...")
    }
    
      private func enlargeTrackView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    //        MARK: - @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        
        self.tabBarDelegate?.minimizeTrackDetailController()
    }
    
    @IBAction func handleCurrentTimerSlider(_ sender: Any) {
        let percentage = currentTimerSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeUnSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeUnSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        
        player.volume = volumeSlider.value
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        
        let cellViewModel = delegate?.moveBackForPreviosTrack()
        guard let cellInfoModel = cellViewModel else { return }
        self.set(viewModel: cellInfoModel)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        
        let cellViewModel = delegate?.moveForwardForPreviosTrack()
        guard let cellInfoModel = cellViewModel else { return }
        self.set(viewModel: cellInfoModel)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniTrackPauseButton.setImage(UIImage(named: "icons8-pause-squared-50"), for: .normal)
            enlargeTrackView()
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniTrackPauseButton.setImage(UIImage(named: "icons8-play-button-circled-50"), for: .normal)
            reduceTrackView()
        }
    }
}
