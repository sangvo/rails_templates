def apply_web_variant!
  use_source_path __dir__

  apply 'Gemfile.rb'
  apply 'app/template.rb'
end

apply_web_variant!
