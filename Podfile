# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

def all_pods
    pod 'SwiftLint', '~> 0.33.0'
    pod 'Firebase/Auth'
    pod 'Alamofire', '~> 4.8.2'
    pod 'SnapKit', '~> 5.0.0'
end

target 'juju' do
    all_pods
end

target 'jujuTests' do
    all_pods
    pod 'Nimble-Snapshots', '~> 7.1.0'
    pod 'Quick', '~> 2.1.0'
    pod 'Nimble', '~> 8.0.2'
end
