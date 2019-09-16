# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!

def all_pods
    pod 'SwiftLint', '~> 0.33.0'
    pod 'Firebase/Firestore'
    pod 'Firebase/Auth'
    pod 'SnapKit', '~> 5.0.0'
    pod 'Fabric', '~> 1.10.2'
    pod 'Crashlytics', '~> 3.13.4'
    pod 'lottie-ios'
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
