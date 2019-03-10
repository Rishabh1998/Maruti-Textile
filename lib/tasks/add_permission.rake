namespace :permissions do

  desc "Takes permission as an input and create three permissions for it (read, write, full)."
  task add: :environment do
    permission = ENV['permission'].try(:titleize)

    if permission.blank?
      raise 'Error: Permission is required!'
    else
      permission = permission.titleize.gsub(" ", "")
    end

    ['View', 'Manage'].each do |type|
      name = "#{type}#{permission}"
      code = name.underscore
      Permission.find_or_create_by!({ name: name, code: code })
      puts "Permission Added : #{name}"
    end
  end
end