if Rails.env.development?
  Admin::User.create!(email: 'admin@gmail.com', password: 'password', password_confirmation: 'password') if Admin::User.find_by(email: 'admin@gmail.com').nil?
end

Server.init

Draft::Armor::Head.find_or_create_by!(name: 'Helmet 1', model: "head1", test: true)
Draft::Armor::Body.find_or_create_by!(name: 'Armor 1', model: "armor1", test: true)
Draft::Armor::Legs.find_or_create_by!(name: 'Pants 1', model: "boots1", test: true)
Draft::Armor::Head.find_or_create_by!(name: 'Helmet 2', model: "head2", test: true)
Draft::Armor::Body.find_or_create_by!(name: 'Armor 2', model: "armor2", test: true, disable_body: true)
Draft::Armor::Legs.find_or_create_by!(name: 'Pants 2', model: "boots2", test: true, disable_legs: true)
Draft::Armor::Head.find_or_create_by!(name: 'Helmet 3', model: "head3", test: true)
Draft::Armor::Body.find_or_create_by!(name: 'Armor 3', model: "armor3", test: true, disable_body: true, disable_arms: true)
Draft::Armor::Legs.find_or_create_by!(name: 'Pants 3', model: "boots3", test: true, disable_legs: true)
Draft::Armor::Head.find_or_create_by!(name: 'Helmet 4', model: "head4", test: true)
Draft::Armor::Body.find_or_create_by!(name: 'Armor 4', model: "armor4", test: true)
Draft::Armor::Legs.find_or_create_by!(name: 'Pants 4', model: "boots4", test: true)
Draft::Armor::Head.find_or_create_by!(name: 'Helmet 5', model: "head5", test: true)
Draft::Armor::Body.find_or_create_by!(name: 'Armor 5', model: "armor5", test: true)
Draft::Armor::Legs.find_or_create_by!(name: 'Pants 5', model: "boots5", test: true, disable_legs: true)
Draft::Weapon::Secondary.find_or_create_by!(name: 'Shield 1', model: "shield1", test: true)
Draft::Weapon::Secondary.find_or_create_by!(name: 'Shield 2', model: "shield2", test: true)
Draft::Weapon::Secondary.find_or_create_by!(name: 'Shield 3', model: "shield3", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Sword 1', model: "sword1", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Sword 2', model: "sword2", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Sword 3', model: "sword3", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Axe 1', model: "axe1", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Axe 2', model: "axe2", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Club 1', model: "club1", test: true)
Draft::Weapon::Primary.find_or_create_by!(name: 'Club 2', model: "club2", test: true)

Player.test("lepple")
Player.test("raven")
Player.test("natafive")

puts "Seed done"
