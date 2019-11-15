Pod::Spec.new do |s|
  s.name             = 'FloatWindow'
  s.version          = '1.0.8'
  s.summary          = 'FloatWindow like WeChat''s floating ball can open a controller and hide it into a ball.'
 
  s.homepage         = 'https://github.com/janlionly/FloatWindow'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'janlionly' => 'janlionly@gmail.com' }
  s.source           = { :git => 'https://github.com/janlionly/FloatWindow.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/janlionly'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'Source/*'
  s.frameworks = 'UIKit'
  s.swift_versions = ['4.2', '5.0', '5.1']
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end