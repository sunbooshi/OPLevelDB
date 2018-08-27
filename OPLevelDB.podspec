Pod::Spec.new do |s|
  s.name             = 'OPLevelDB'
  s.version          = '0.1.0'
  s.summary          = 'Objc wrapper for leveldb.'

  s.description      = <<-DESC
Objc wrapper for leveldb.
                       DESC

  s.homepage         = 'https://github.com/sunboshi/OPLevelDB'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunboshi' => 'boshi@sunboshi.tech' }
  s.source           = { :git => 'https://github.com/sunboshi/OPLevelDB.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'OPLevelDB/*', 'OPLevelDB/leveldb/include/leveldb/*'
  s.public_header_files = 'OPLevelDB/*.h'

  s.compiler_flags = '-lc++'

  s.preserve_paths = 'OPLevelDB/leveldb/lib/libleveldb.a'
  s.vendored_library = 'OPLevelDB/leveldb/lib/libleveldb.a'

  s.header_dir = 'leveldb'

end
