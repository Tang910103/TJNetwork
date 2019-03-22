Pod::Spec.new do |s|
    s.name         = "TJNetwork"
    s.version      = "0.0.1"
    s.summary      = "AFNetworking二次封装，内部依赖了AFNetworking，YYCache"
    s.description  = "AFNetworking二次封装，内部依赖了AFNetworking，YYCache"
    s.homepage     = "https://github.com/Tang910103"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Tang杰" => "tang910103@qq.com" }
    s.platform     = :ios
    s.source       = { :git => "https://github.com/Tang910103/TJNetwork.git", :tag => "#{s.version}" }
    s.platform     = :ios, '8.0'
    s.source_files  = "TJNetwork/**/*.{h,m}"
    s.dependency "AFNetworking"
    s.dependency "YYCache"

end
