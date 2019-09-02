
Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "TransitionalLoader"
s.summary = "A smooth loader that can be used on any UIView subclass"
s.requires_arc = true
s.description = "A smooth loader that can be used on any UIView subclass"

# 2
s.version = "0.0.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Ammar Altahhan" => "ammar.tahhan@hungerstation.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/HungerStation"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/HungerStation/TransitionalLoader.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "TransitionalLoader/**/*.{swift}"

# 9
# s.resources = "TransitionalLoader/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
