Pod::Spec.new do |s|
  s.name         = "GPX"
  s.version      = "0.1.0"
  s.summary      = "An Objective-C GPX parser/generator"
  s.description  = <<-DESC
                    This project provide a iOS & macOS framework for parsing/generating GPX files.
                    This Framework parses the GPX from a URL or Strings and create Objective-C Instances of GPX structure.
                   DESC
  s.homepage     = "https://github.com/hulab/GPX"
  s.license      = 'MIT'
  s.author       = { "Maxime Epain" => "maxime@mapstr.com" }
  s.source       = { :git => "https://github.com/hulab/GPX.git", :tag => "v#{s.version}" }
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.6'
  s.default_subspec = 'Core'



  ### Subspecs

  s.subspec 'Core' do |ss|
    ss.source_files = 'GPX/*.{h,m}'
    ss.private_header_files =   'GPX/GPXElementSubclass.h',
                                'GPX/GPXXML.h'
  end

  s.subspec 'Logger' do |ss|
    ss.source_files = 'GPXLogger/*.{h,m}'
    ss.dependency 'GPX/Core'
  end
end
