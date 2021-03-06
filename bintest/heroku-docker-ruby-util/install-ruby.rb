require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('install-ruby') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rack"
GEMFILE
      end
      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/ruby-2.2.2")
      assert_true File.exist?(profiled_path)
      assert_include `bash -c "source #{profiled_path} && ruby -v"`, "ruby 2.2.2"
    end
  end
end
