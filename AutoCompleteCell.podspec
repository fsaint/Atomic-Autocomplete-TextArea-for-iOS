Pod::Spec.new do |s|
  s.name         = "AutoCompleteCell"
  s.version      = "0.0.3"
  s.summary      = "An implementation of a textarea with atomic elements (like Mail's email address fields)."
  s.homepage     = "http://github.com/fsaint/Atomic-Autocomplete-TextArea-for-iOS"
  s.license      = 'MIT'
  s.author       = { "Felipe Saint-Jean" => "fsaint@gmail.com" }
  s.source       = { :git => "https://github.com/fsaint/Atomic-Autocomplete-TextArea-for-iOS.git", :tag => "0.0.3" }
  s.platform     = :ios, '6.0'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
  s.frameworks = 'AddressBook', 'CoreGraphics', 'UIKit', 'Foundation'
end
