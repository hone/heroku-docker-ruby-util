require 'open3'
require 'tmpdir'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/heroku-docker-ruby-mruby")

assert('detect-ruby') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rack"
GEMFILE
      end

      output, status = Open3.capture2("#{BIN_PATH}", "detect-ruby", "Gemfile")

      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "ruby-2.2.2"
    end
  end
end

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

      output, status = Open3.capture2("#{BIN_PATH}", "install-ruby", "Gemfile", install_path, profiled_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/ruby-2.2.2")
      assert_true File.exist?(profiled_path)
      assert_include `bash -c "source #{profiled_path} && ruby -v"`, "ruby 2.2.2"
    end
  end
end

assert('install-node') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2("#{BIN_PATH}", "install-node", "0.12.7", install_path, profiled_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/node-0.12.7")
      assert_true File.exist?(profiled_path)
      assert_include `bash -c "source #{profiled_path} && node -v"`, "v0.12.7"
    end
  end
end
