//
//  TrackerClosures.swift
//  Tracker
//
//  Created by Omar Brugna on 28/04/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

public typealias TrackerClosureVoid = () -> ()
public typealias TrackerClosureInt = (Int) -> ()
public typealias TrackerClosureBool = (Bool) -> ()
internal typealias TrackerClosureDate = (Date) -> ()
internal typealias TrackerClosureDouble = (Double) -> ()
internal typealias TrackerClosureString = (String) -> ()
internal typealias TrackerClosureConnection = (Int, TrackerConnectionResult, String?) -> ()
