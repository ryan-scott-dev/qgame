SDK_VERSION = '6.1'

MRuby::Toolchain.new(:ios) do |conf|
  toolchain :clang
  
  arch 'i386'
  sdk 'iphonesimulator'
  sdk_version "#{SDK_VERSION}"
  platform '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform'
  sdk_path "#{platform}/Developer/SDKs/iPhoneSimulator#{sdk_version}.sdk"

  conf.bins = %w()
  [conf.cc, conf.cxx, conf.objc, conf.asm].each do |cc|
    cc.command = `xcode-select -print-path`.chomp+'/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang'
    cc.flags = [ENV['CFLAGS'] || ["-arch #{arch}", "-miphoneos-version-min=#{sdk_version}"]]
    cc.flags << ["-isysroot #{sdk_path}"]
    cc.flags << %Q[-fmessage-length=0 -std=gnu99 -fpascal-strings -fexceptions -fasm-blocks -gdwarf-2]
    cc.flags << %Q[-fobjc-abi-version=2]
    cc.defines = ['PLATFORM_IOS', '__IPHONEOS__']
  end
  
  conf.linker.flags = ENV['LDFLAGS'] || ["-arch #{arch}"]
end

MRuby::Toolchain.new(:ios_arm) do |conf|
  toolchain :clang
  
  arch 'armv7'
  sdk 'iphoneos'
  sdk_version "#{SDK_VERSION}"
  platform '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform'
  sdk_path "#{platform}/Developer/SDKs/iPhoneOS#{sdk_version}.sdk"
  
  conf.bins = %w()
  [conf.cc, conf.cxx, conf.objc, conf.asm].each do |cc|
    cc.command = `xcode-select -print-path`.chomp+'/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang'
    cc.flags = [ENV['CFLAGS'] || ["-arch #{arch}", "-miphoneos-version-min=#{sdk_version}"]]
    cc.flags << ["-isysroot #{sdk_path}"]
    cc.flags << %Q[-fmessage-length=0 -std=gnu99 -fpascal-strings -fexceptions -gdwarf-2]
    cc.flags << %Q[-fobjc-abi-version=2]
    cc.defines = ['PLATFORM_IOS', '__IPHONEOS__']
  end
  
  conf.linker.flags = ENV['LDFLAGS'] || ["-arch #{arch}"]
end