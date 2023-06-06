#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint particle_biconomy.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'particle_biconomy'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin project for particle biconomy'
  s.description      = <<-DESC
A flutter plugin project for particle biconomy
                       DESC
  s.homepage         = 'https://particle.network'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SunZhiC' => 'sunzhichao@minijoy.work' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.swift_version = '5.0'


  s.dependency 'ParticleBiconomy'
end
