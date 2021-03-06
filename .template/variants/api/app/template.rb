# Controllers
directory 'app/controllers/concerns'
directory 'app/controllers/api/v1'

# Services
directory 'app/services'

inject_into_class 'app/controllers/api/v1/base_controller.rb', 'Api::V1::BaseController' do
  <<-EOT
  include Localization
  EOT
end
