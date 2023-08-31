workspace 'Tracker.xcworkspace'

use_frameworks!

def required_pods
  pod 'Alamofire', '= 5.7.1'
  pod 'RealmSwift', '= 10.40.2'
end

target 'Tracker' do
  project 'Tracker.xcodeproj'
  platform :ios, '12.0'
  required_pods
end

target 'TrackerWatch' do
  project 'Tracker.xcodeproj'
  platform :watchos, '8.0'
  required_pods
end

target 'TrackerTests' do
  platform :ios, '12.0'
  required_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 12.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
      if config.build_settings['WATCHOS_DEPLOYMENT_TARGET'].to_f < 8.0
        config.build_settings['WATCHOS_DEPLOYMENT_TARGET'] = '8.0'
      end
    end
  end
end
