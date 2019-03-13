Dir[Rails.root.join('common/app/lib/*.rb')].each {|file| require file }
Dir[Rails.root.join('common/app/models/concerns/*.rb')].each {|file| require file }
Dir[Rails.root.join('common/app/services/**/*.rb')].reverse.each {|file| require file }
#require_relative 'app/models/backend_main_app_database.rb'
Dir[Rails.root.join('common/app/models/*.rb')].each {|file| require file }