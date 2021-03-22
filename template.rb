require "shellwords"

# Variables
APP_NAME = app_name
APP_NAME_HUMANIZED = app_name.split(/[-_]/).map(&:capitalize).join(" ").gsub(/ Web$/, "")

RUBY_VERSION = "2.7.2".freeze
POSTGRES_VERSION = "12.1".freeze
REDIS_VERSION = "5.0.7".freeze

# Variants api or web MVC
API_VARIANT = options[:api] || ENV["API"] == "true"
WEB_VARIANT = !API_VARIANT

if WEB_VARIANT
  NODE_VERSION="14.15.4".freeze
  NODE_SOURCE_VERSION="14".freeze # Used in Dockerfile https://github.com/nodesource/distributions
end

def apply_template!(template_root)
  use_source_path template_root

  delete_test_folder

  template "Gemfile.tt", force: true
  template '.ruby-version.tt', force: true
  template 'README.md.tt', force: true
  template '.env.example.tt', force: true
  apply '.gitignore.rb'

  after_bundle do
    use_source_path template_root

    # Stop the spring before using the generators as it might hang for a long time
    # Issue: https://github.com/rails/spring/issues/486
    run 'spring stop'
  end

    # Variants
  apply '.template/variants/api/template.rb' if API_VARIANT
  apply '.template/variants/web/template.rb' if WEB_VARIANT
end

def use_source_path(source_path)
  @source_paths.unshift(source_path)
end

def remote_repository
  require "tmpdir"
  tempdir = Dir.mktmpdir("rails-templates")
  at_exit { FileUtils.remove_entry(tempdir) }

  git clone: [
    "--quiet",
    "https://github.com/sangvo/rails-templates.git",
    tempdir
  ].map(&:shellescape).join(" ")

  if (branch = __FILE__[%r{rails-templates/(.+)/template.rb}, 1])
    Dir.chdir(tempdir) { git checkout: branch }
  end

  tempdir
end

def delete_test_folder
  FileUtils.rm_rf("test")
end

# Init the source path
@source_path ||= []
# Setup the template root path
# If the template file is the url, clone the repo to the tmp directory

template_root = __FILE__ =~ %r{\Ahttps?://} ? remote_repository : __dir__
use_source_path template_root

apply_template!(template_root)
