//
//  RecordSoundViewController.swift
//  voiceChanger
//
//  Created by MUHAMMAD EHAB on 3/25/20.
//  Copyright © 2020 MUHAMMAD EHAB. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation





class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder :AVAudioRecorder!

    
    @IBOutlet weak var darklabel: UILabel!
    @IBOutlet weak var outletswitch: UISwitch!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var record: UIButton!
    
    @IBOutlet weak var Stoprecording: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Stoprecording.isEnabled=false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear is called")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewDidappear is called")
    }


    @IBAction func darkaction(_ sender: Any) {
        if outletswitch.isOn==true{
            view.backgroundColor=UIColor.black
            darklabel.textColor=UIColor.white
            darklabel.text = "Bright mode"
        }else{
            view.backgroundColor=UIColor.white
            darklabel.textColor=UIColor.black
            darklabel.text = "Dark mode"
        }
        
    }
    @IBAction func Recordaudio(_ sender: Any) {
        Stoprecording.isEnabled=true
        record.isEnabled=false
        recordLabel.text="Record in progress"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func Stoprecord(_ sender: Any) {
        record.isEnabled=true
        Stoprecording.isEnabled=false
        recordLabel.text="Tap to record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "Stoprecording", sender: audioRecorder.url)
        }
        else{
            print("recording was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Stoprecording" {
            let playSoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

