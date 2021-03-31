insert_into_file 'Gemfile', after: %r{gem 'pundit'.*\n} do
  <<~EOT
    # Assets
    gem 'webpacker', '~>5.2.0' # Transpile app-like JavaScript
    gem 'sass-rails' # SASS
  EOT
end
