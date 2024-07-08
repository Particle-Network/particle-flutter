#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint particle_connect.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'particle_connect'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin project for particle connect'
  s.description      = <<-DESC
A flutter plugin project for particle connect
                       DESC
  s.homepage         = 'http://particle.network'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SunZhiC' => 'sunzhichao@minijoy.work' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.swift_version = '5.7'

  s.dependency 'ParticleConnect'
  s.dependency 'ConnectWalletConnectAdapter'
  s.dependency 'ConnectSolanaAdapter'
  s.dependency 'ConnectEVMAdapter'
  s.dependency 'ConnectPhantomAdapter'
  s.dependency 'ConnectCommon'
end
