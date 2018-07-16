#
# Be sure to run `pod lib lint CommonBusiness.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CommonBusiness'
  s.version          = '1.0.0'
  s.summary          = 'This library makes a public library, it is independent of the project, we can use the public library in the project.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library makes a public library, it is independent of the project, we can use the public library in the project.When the development of public library, finally used directly insert this project.
                       DESC

  s.homepage         = 'http://10.16.0.209/TophlcComponents/CommonBusiness'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '廖长平' => 'liaochangping@tophlc.com' }
  s.source           = { :git => 'http://10.16.0.209/TophlcComponents/CommonBusiness.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CommonBusiness/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CommonBusiness' => ['CommonBusiness/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
