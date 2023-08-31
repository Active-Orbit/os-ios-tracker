//
//  TrackerPreferencesKeys.swift
//  Tracker
//
//  Created by Omar Brugna on 27/03/2020.
//  Copyright © 2020 Active Orbit. All rights reserved.
//

import Foundation

internal class TrackerPreferencesKeys {
    
    // backend preferences
    internal static let preference_backend_base_url = "tracker.backend.base.url"
    internal static let preference_backend_target_app = "tracker.backend.target.app"
    
    // configuration preferences
    internal static let preference_configuration_log_level = "tracker.configuration.log.level"
    internal static let preference_configuration_steps_per_second_threshold = "tracker.configuration.steps.per.second.threshold"
    internal static let preference_configuration_steps_per_brisk_minute_threshold = "tracker.configuration.steps.per.brisk.minute.threshold"
    internal static let preference_configuration_location_tracking_enabled = "tracker.configuration.location.tracking.enabled"
    internal static let preference_configuration_minimum_segment_duration = "tracker.configuration.minimum.segment.duration"
    internal static let preference_configuration_intensity_enabled = "tracker.configuration.intensity.enabled"
    internal static let preference_configuration_steps_enabled = "tracker.configuration.steps.enabled"
    internal static let preference_configuration_cycling_enabled = "tracker.configuration.cycling.enabled"
    internal static let preference_configuration_automotive_enabled = "tracker.configuration.automotive.enabled"
    internal static let preference_configuration_wify_analysis_enabled = "tracker.configuration.wify.analysis.enabled"
    internal static let preference_configuration_data_upload_enabled = "tracker.configuration.data.upload.enabled"
    internal static let preference_configuration_use_legacy_data_upload = "tracker.configuration.use.legacy.data.upload"
    internal static let preference_configuration_user_registration_enabled = "tracker.configuration.user.registration.enabled"
    internal static let preference_configuration_use_legacy_user_registration = "tracker.configuration.use.legacy.user.registration"
    
    // routine preferences
    internal static let preference_routine_first_install = "tracker.routine.first.install"
    internal static let preference_routine_last_analyse = "tracker.routine.last.analyse"
    internal static let preference_routine_last_user_update = "tracker.routine.last.user.update"
    internal static let preference_routine_last_data_upload = "tracker.routine.last.data.upload"
    internal static let preference_routine_last_notes_upload = "tracker.routine.last.notes.upload"
    
    // user preferences
    internal static let preference_user_id = "tracker.user.id"
    internal static let preference_user_push_token = "tracker.user.push.token"
    internal static let preference_user_name = "tracker.user.name"
    internal static let preference_user_gender = "tracker.user.gender"
    internal static let preference_user_age = "tracker.user.age"
    internal static let preference_user_age_range = "tracker.user.age.range"
    internal static let preference_user_weight = "tracker.user.weight"
    internal static let preference_user_height = "tracker.user.height"
    
    // tracking preferences
    internal static let preference_tracking_enabled = "tracker.tracking.enabled"
    internal static let preference_tracking_location_accuracy = "tracker.tracking.location.accuracy"
    
    // options preferences
    internal static let preference_options_upload_data_agreed = "tracker.options.upload.data.agreed"
}
