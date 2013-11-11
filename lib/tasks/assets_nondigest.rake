require 'fileutils'

desc "Create nondigest versions of all digest assets"
task "assets:precompile" do
  fingerprint = /\-[0-9a-f]{32}\./
  Dir["public/assets/**/*"].each do |file|
    next if file !~ fingerprint
    next if File.directory?(file)
    next if file.split(File::Separator).last =~ /^manifest/

    nondigest = file.sub fingerprint, '.'
    FileUtils.cp file, nondigest, verbose: true
  end
end
