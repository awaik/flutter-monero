#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint monero_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'monero_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.library = 'c++'
  s.xcconfig = { 'CLANG_CXX_LANGUAGE_STANDARD' => 'c++11', 'CLANG_CXX_LIBRARY' => 'libc++' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  #s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS' => 'arm64', 'ENABLE_BITCODE' => 'NO' }
  s.swift_version = '5.0'

  s.subspec 'Iconv' do |iconv|
    iconv.library = "iconv"
  end

  s.subspec 'OpenSSL' do |openssl|
    openssl.preserve_paths = 'external/include/**/*.h'
    openssl.vendored_libraries = 'external/lib/libcrypto.a', 'external/lib/libssl.a'
    openssl.libraries = 'crypto',' ssl'
    openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/ios/external/include/**" }
    openssl.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load '$(PODS_TARGET_SRCROOT)/external/lib/libssl.a' -force_load '$(PODS_TARGET_SRCROOT)/external/lib/libcrypto.a'" }
  end

  s.subspec 'Sodium' do |sodium|
    sodium.preserve_paths = 'external/include/**/*.h'
    sodium.vendored_libraries = 'external/lib/libsodium.a'
    sodium.libraries = 'sodium'
    sodium.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/ios/external/include/**" }
    sodium.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/external/lib/libsodium.a" }
  end

  s.subspec 'Unbound' do |unbound|
    unbound.preserve_paths = 'external/include/**/*.h'
    unbound.vendored_libraries = 'external/lib/libunbound.a'
    unbound.libraries = 'unbound'
    unbound.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/ios/external/include/**" }
    unbound.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/external/lib/libunbound.a" }
  end

  s.subspec 'Boost' do |boost|
    boost.preserve_paths = 'external/include/**/*.h',
    boost.vendored_libraries =  'external/lib/libboost.a',
    boost.libraries = 'boost'
    boost.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/ios/external/include/**" }
    boost.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/external/lib/libboost.a" }
  end

  s.subspec 'Monero' do |monero|
    monero.preserve_paths = 'external/include/**/*.h'
    monero.vendored_libraries = 'external/lib/libmonero.a'
    monero.libraries = 'monero'
    monero.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/external/include" }
    monero.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/external/lib/libmonero.a" }
  end

  s.subspec 'Zmq' do |zmq|
    zmq.preserve_paths = 'external/include/**/*.h'
    zmq.vendored_libraries = 'external/lib/libzmq.a'
    zmq.libraries = 'zmq'
    zmq.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/external/include" }
    zmq.pod_target_xcconfig = { "OTHER_LDFLAGS" => "-force_load $(PODS_TARGET_SRCROOT)/external/lib/libzmq.a" }
  end

end
