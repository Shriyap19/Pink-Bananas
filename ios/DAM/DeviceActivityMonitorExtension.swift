//
//  DeviceActivityMonitorExtension.swift
//  DAM
//
//  Created by Jared Sinai Hernandez Adame on 10/16/25.
//

import DeviceActivity
import os.log
import Foundation


let logger = OSLog(subsystem: "com.tcsm.orangeteamproject", category: "DeviceActivityMonitor")

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
        os_log("interval started 2", log:logger)
        
        UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.removeObject(forKey: "goal_\(activity.rawValue)")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        // Handle the start of the interval.
        os_log("interval ended", log:logger)
        let wasFullfilled = UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.bool(forKey: "goal_\(activity.rawValue)")
        if wasFullfilled == nil {
            UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.set(true, forKey:"goal_\(activity.rawValue)")
        }
        
        UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.set(true,forKey: "dayChange_\(activity.rawValue)")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.set(false,forKey:"goal_\(activity.rawValue)")
        // Handle the event reaching its threshold.
        // Handle the start of the interval.
        os_log("event reached its threshold", log:logger)
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
        // Handle the start of the interval.
        os_log("interval will start warning", log:logger)
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
        // Handle the start of the interval.
        os_log("interval will end warning", log:logger)
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        UserDefaults(suiteName: "group.com.tcsm.orangeteamproject")?.set(true,forKey:"show_alert_for_\(activity.rawValue)")
        
        // Handle the warning before the event reaches its threshold.
        os_log("event will reach threshold", log:logger)
    }
}
