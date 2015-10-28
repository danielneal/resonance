//
//  FirstViewController.swift
//  Resonance
//
//  Created by Daniel Neal on 28/10/2015.
//  Copyright © 2015 Daniel Neal. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , EZMicrophoneDelegate, EZRecorderDelegate, EZAudioPlayerDelegate {

    lazy var microphone: EZMicrophone =  EZMicrophone.init(delegate: self);
    var recorder: EZRecorder?
    var isRecording: Bool = false;
    var audioPlayer = EZAudioPlayer.init()
    let audioFileName = "/tmp/resonance.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func newRecorder() ->  EZRecorder! {
        return EZRecorder.init(URL: NSURL.init(fileURLWithPath: audioFileName), clientFormat:self.microphone.audioStreamBasicDescription(), fileType:EZRecorderFileType.M4A)
    }
    
    func recorderUpdatedCurrentTime(recorder: EZRecorder!) {
       let currentTime=recorder.formattedCurrentTime
        dispatch_async(dispatch_get_main_queue()){
            self.recordingTime.text=currentTime
        }
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {

        if (self.isRecording)
        {
            self.recorder!.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
    }

    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func playBackPressed(sender: AnyObject) {
        let audioFile=EZAudioFile.init(URL: NSURL.init(fileURLWithPath: audioFileName))
        audioPlayer.playAudioFile(audioFile)
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, inAudioFile audioFile: EZAudioFile!) {
      
    }
    
    @IBOutlet weak var recordingTime: UILabel!
    
    @IBAction func onStartPress(sender: AnyObject) {
        if (self.isRecording)
        {
            self.startButton.setTitle("Start", forState:UIControlState.Normal)
            self.isRecording=false
            microphone.stopFetchingAudio()
            self.recorder!.closeAudioFile()
        }
        else
        {
            self.startButton.setTitle("Stop", forState:UIControlState.Normal)
            self.recorder = newRecorder()
            self.recorder!.delegate=self
            self.isRecording=true
            microphone.startFetchingAudio()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

