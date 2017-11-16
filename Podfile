target ‘WeatherApp’ do
  use_frameworks!
pod 'Alamofire', '~> 4.5'
pod 'ReachabilitySwift'
pod 'GooglePlaces'
pod 'ObjectMapper', '2.2.9'
pod 'TTGSnackbar', '~> 1.5'
pod 'MBProgressHUD', '~> 1.0'
pod 'RxSwift', '~> 3.0.0.beta.1'
pod 'RxCocoa', '~> 3.0.0.beta.1'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end
