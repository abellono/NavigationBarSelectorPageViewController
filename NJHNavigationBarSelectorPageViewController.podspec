Pod::Spec.new do |s|
  s.name             = "NJHNavigationBarSelectorPageViewController"
  s.version          = "1.0.7"
  s.summary          = "A view controller that shows synchronizes a selection bar with swipes in a page controller."
  s.description      = <<-DESC
                       A subclass of UIPageViewController that displays a view in the navigation bar that indicates what view controller's view the user is currently looking at. The selection
                       bar animates nicely in sync with the user's horizontal scrolling in the page controller. The appearence is highly adjustable, as most of the properties are public.
                       DESC
  s.homepage         = "https://github.com/abellono/NavigationBarSelectorPageViewController"
  s.license          = 'MIT'
  s.author           = {"Hakon Hanesand" => "hakon@abello.no", "Nikolai Heum" => "nikolai@abello.no"}
  s.source           = {:git => "https://github.com/abellono/NavigationBarSelectorPageViewController.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m,swift}'
  s.resource_bundles = {
    'NJHNavigationBarSelectorPageViewController' => ['Pod/**/*.{png,xib}']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
end
