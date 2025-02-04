if Rails.env.development?
  Admin::User.create!(email: 'admin@gmail.com', password: 'password', password_confirmation: 'password') if Admin::User.find_by(email: 'admin@gmail.com').nil?
end

player = Player.cc

if player.inventory.blank?
  Draft::Armor::Body.find_or_create_by!(name: 'Grey Armor', model: "armor1").spawn_for(player)
  Draft::Armor::Body.find_or_create_by!(name: 'Red Armor', model: "armor2").spawn_for(player)
  Draft::Armor::Body.find_or_create_by!(name: 'Skull Armor', model: "armor3").spawn_for(player)
  Draft::Armor::Legs.find_or_create_by!(name: 'Grey Pants', model: "boots1").spawn_for(player)
  Draft::Armor::Legs.find_or_create_by!(name: 'Red Pants', model: "boots2").spawn_for(player)
  Draft::Armor::Legs.find_or_create_by!(name: 'Skull Pants', model: "boots3").spawn_for(player)
  Draft::Weapon::Primary.find_or_create_by!(name: 'Steel Sword', model: "sword1").spawn_for(player)
  Draft::Weapon::Primary.find_or_create_by!(name: 'Wood Sword', model: "sword2").spawn_for(player)
  Draft::Weapon::Secondary.find_or_create_by!(name: 'Steel Shield', model: "shield1").spawn_for(player)
  Draft::Weapon::Secondary.find_or_create_by!(name: 'Wood Shield', model: "shield2").spawn_for(player)
end
