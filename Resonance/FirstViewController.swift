//
//  FirstViewController.swift
//  Resonance
//
//  Created by Daniel Neal on 28/10/2015.
//  Copyright © 2015 Daniel Neal. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController , EZMicrophoneDelegate, EZRecorderDelegate {
    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func newRecorder() ->  EZRecorder! {
        return EZRecorder.init(URL: NSURL.init(fileURLWithPath: "/tmp/resonance.m4a"), clientFormat:self.microphone.audioStreamBasicDescription(), fileType:EZRecorderFileType.M4A)
    }
    
    lazy var microphone: EZMicrophone =  EZMicrophone.init(delegate: self);
    
    var recorder: EZRecorder?

    var isRecording: Bool = false;
    
    func recorderUpdatedCurrentTime(recorder: EZRecorder!) {
       let currentTime=recorder.formattedCurrentTime
        dispatch_async(dispatch_get_main_queue()){
            self.recordingTime.text=currentTime
        }
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {

        if (self.isRecording)
        {
            // Since we set the recorder's client format to be that of the EZMicrophone instance,
            // the audio data coming in represented by the AudioBufferList can directly be provided
            // to the EZRecorder. The EZRecorder will internally convert the audio data from the
            // `clientFormat` to `fileFormat`.
            self.recorder!.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
    }

    @IBOutlet weak var recordingTime: UILabel!
    
    @IBAction func onStartPress(sender: AnyObject) {
        if (!self.isRecording)
        {
            self.recorder = newRecorder()
            self.recorder!.delegate=self
            self.startButton.setTitle("Stop", forState:UIControlState.Normal)
            self.isRecording=true
            microphone.startFetchingAudio()
        }
        else
        {
            self.isRecording=false
            microphone.stopFetchingAudio()
            self.recorder!.closeAudioFile()
            self.recorder=newRecorder()
            self.startButton.setTitle("Start", forState:UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

