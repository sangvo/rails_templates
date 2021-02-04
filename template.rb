require "shellwords"

# Variables
APP_NAME = app_name
APP_NAME_HUMANIZED = app_name.split(/[-_]/).map(&:capitalize).join(' ').gsub(/ Web$/, '')

RUBY_VERSION = '2.7.2'.freeze
POSTGRES_VERSION = '12.1'.freeze
REDIS_VERSION = '5.0.7'.freeze

# Variants api or web MVC
API_VARIANT = options[:api] || ENV['API'] == 'true'
WEB_VARIANT = !API_VARIANT

if WEB_VARIANT
  NODE_VERSION='14.15.4'.freeze
  NODE_SOURCE_VERSION='14'.freeze # Used in Dockerfile https://github.com/nodesource/distributions
end

def apply_template!

end

def use_source_path(source_path)
  @source_paths.unshift(source_path)
end

def remote_repository
  require 'tmpdir'
  tempdir = Dir.mktmpdir('rails-templates')
  at_exit { FileUtils.remove_entry(tempdir) }

  git clone: [
    '--quiet',
    'https://github.com/sangvo/rails-templates.git',
    tempdir
  ].map(&:shellescape).join(' ')

  if (branch = __FILE__[%r{rails-templates/(.+)/template.rb}, 1])
    Dir.chdir(tempdir) { git checkout: branch }
  end

  tempdir
end

def delete_test_folder
  FileUtils.rm_rf('test')
end

# Init the source path
@source_path ||= []
# Setup the template root path
# If the template file is the url, clone the repo to the tmp directory

template_root = __FILE__ =~ %r{\Ahttps?://} ? remote_repository : __dir__
use_source_path template_root

apply_template!(template_root)