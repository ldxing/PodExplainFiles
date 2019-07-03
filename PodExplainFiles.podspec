#
# Be sure to run `pod lib lint PodExplainFiles.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PodExplainFiles'
  s.version          = '0.1.2'
  s.summary          = 'this is a test pod repo for private pod'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  包含两个文件：YQDeviceManager和YQWeakProxy；这两个文件分别来自文件的目的是什么也不知道啊
                       DESC

  s.homepage         = 'https://github.com/ldxing/PodExplainFiles'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ldxing' => 'ldxing52mn@163.com' }
  s.source           = { :git => 'https://github.com/ldxing/PodExplainFiles.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PodExplainFiles/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PodExplainFiles' => ['PodExplainFiles/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
