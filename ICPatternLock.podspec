#
# Be sure to run `pod lib lint ICPatternLock.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ICPatternLock'
  s.version      = "0.9.0.1"
  s.summary      = "ICPatternLock is a screen lock for your app access. "

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ICPatternLock is a screen lock for your app access. It's familiar to most people and intuitively clear, because a pattern is much more easy to remember. 
What is more, it's also convenient for developers to use, of course, and to extend.
                       DESC

  s.homepage         = 'https://github.com/IvanChan/ICPatternLock'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '_ivanC' => '_ivanC' }
  s.source           = { :git => 'https://github.com/IvanChan/ICPatternLock.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'ICPatternLock/Classes/**/*'
  s.public_header_files = 'ICPatternLock/Classes/**/*.h'
  
  # s.resource_bundles = {
  #   'ICPatternLock' => ['ICPatternLock/Assets/*.png']
  # }

  
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
