namespace :xbindr do
  desc "XBindR | init app"
  task :init => :environment do
    puts "create administrator for xbindr"
    puts "Please input username for admin"
    $stdout.flush
    name = $stdin.gets.chomp
    puts "Please input password for admin"
    $stdout.flush
    password = $stdin.gets.chomp
    u = User.new(name: name)
    u.password = password
    u.password_confirmation = password
    if u.save
      puts "Admin successfully created"
    else
      puts "Fail to create admin because of:"
      puts u.errors.full_messages
    end
  end
end
