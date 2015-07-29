#
# Be sure to run `pod lib lint NJHNavigationBarSelectorPageViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NJHNavigationBarSelectorPageViewController"
  s.version          = "0.1.0"
  s.summary          = "A short description of NJHNavigationBarSelectorPageViewController."
  s.description      = <<-DESC
                       An optional longer description of NJHNavigationBarSelectorPageViewController

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/NJHNavigationBarSelectorPageViewController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Hakon Hanesand" => "hakon@hanesand.no" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/NJHNavigationBarSelectorPageViewController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'NJHNavigationBarSelectorPageViewController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
