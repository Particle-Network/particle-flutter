#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint particle_auth.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'particle_auth'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin project for particle auth'
  s.description      = <<-DESC
A flutter plugin project for particle auth
                       DESC
  s.homepage         = 'http://particle.network'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SunZhiC' => 'sunzhichao@minijoy.work' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.swift_version = '5.0'


  s.dependency 'ParticleAuthService'
  s.dependency 'BigInt', '~> 5.2.0'
end
