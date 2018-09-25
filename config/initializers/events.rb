ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
    if details[:sql] =~ /INSERT INTO "instance_users"/
      puts caller.join("\n")
      puts "INSTANCE USER INSERTED"
      puts "*" * 50
    end
  end