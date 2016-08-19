Pod::Spec.new do |s|
  s.name         = "EZNetworking"
  s.version      = "0.0.1"
  s.summary      = "A delightful iOS and OS X networking framework."
  s.homepage     = "https://github.com/iphone5s/EZNetworking"
  s.license      = { :type => 'MIT',:file => 'LICENSE' }
  s.author             = { "Ezreal" => "453742103@qq.com" }
  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.source       = { :git => "https://github.com/iphone5s/EZNetworking.git", :tag => s.version }
  s.source_files  = "EZNetworking/*.{h,m}"
  s.requires_arc = true
  s.dependency "AFNetworking"
  s.dependency "PINCache"
end
