desc "Make xcode.project"
task :xcodeproj do
  sh "swift package generate-xcodeproj"
end

desc "Build debug build of MonchCLI"
task :build do
  sh "swift build"
end

desc "Run MonchCLI"
task :run => :build do
  sh "swift run monch -k swift"
end

desc "Compile release build of MonchCLI"
task :compile do
  sh "swift build --disable-sandbox -c release"
end

PREFIX = "/usr/local"

desc "Install MonchCLI"
task :install => :compile do
  sh "mkdir -p #{PREFIX}/bin"
  sh "cp -p ./build/release/monch #{PREFIX}/bin"
end
