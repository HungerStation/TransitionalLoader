
Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "TransitionalLoader"
s.summary = "A smooth loader that can be used on any UIView subclass"
s.requires_arc = true
s.description = "TransitionalLoader extends UIView, to allow you to transform any UIView subclass into an animated loader easily"
s.version = "0.0.2"

s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Ammar Altahhan" => "ammar.tahhan@hungerstation.com" }
s.homepage = "https://hungerstation.com"
s.source = { :git => "https://github.com/HungerStation/TransitionalLoader.git",
:tag => "#{s.version}" }
s.framework = "UIKit"
s.source_files = "TransitionalLoader/**/*.{swift}"
s.swift_version = "4.2"

end
