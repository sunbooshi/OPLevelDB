
Pod::Spec.new do |s|
  s.name             = 'OPLevelDB'
  s.version          = '0.1.0'
  s.summary          = 'Objc wrapper for leveldb.'

  s.description      = <<-DESC
Objc wrapper for leveldb use leveldb-library 1.20.
                       DESC

  s.homepage         = 'https://github.com/sunboshi/OPLevelDB'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sunboshi' => 'boshi@sunboshi.tech' }
  s.source           = { :git => 'https://github.com/sunboshi/OPLevelDB.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.public_header_files = 'OPLevelDB/OPLevelDB.h', 'OPLevelDB/OPLevelDBIteratorItem.h', 'OPLevelDB/OPLevelDBWriteBatch.h'
  s.source_files = 'OPLevelDB/*'

  s.header_dir = 'OPLevelDB'

  s.dependency 'leveldb-library', '= 1.20'

end
