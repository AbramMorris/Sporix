platform :ios, '14.0'

target 'Sporix' do
  use_frameworks!

  pod 'Alamofire', '~> 5.6.0'
  pod 'Kingfisher', '~> 8.0'
  pod 'lottie-ios', '~> 4.2.0'
  pod 'ReachabilitySwift', '~> 5.1'
 
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 14.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        end
      end
    end
  end
end