Pod::Spec.new do |s|
  s.name             = "NJHNavigationBarSelectorPageViewController"
  s.version          = "0.2.2"
  s.summary          = "A subclass of UIPageViewController that shows an animated selection bar in the navigation bar when swiping back and forth between pages."
  s.description      = <<-DESC
                       A subclass of UIPageViewController that displays a view in the navigation bar that indicates what view controller's view the user is currently looking at. The selection
                       bar animates nicely in sync with the user's horizontal scrolling in the page controller. The appearence is highly adjustable, as most of the properties are public.
                       DESC
  s.homepage         = "https://github.com/abellono/NavigationBarSelectorPageViewController"
  s.license          = 'MIT'
  s.author           = {"Hakon Hanesand" => "hakon@hanesand.no"}
  s.source           = {:git => "https://github.com/abellono/NavigationBarSelectorPageViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'NJHNavigationBarSelectorPageViewController' => ['Pod/**/*.{png,xib}']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
end
