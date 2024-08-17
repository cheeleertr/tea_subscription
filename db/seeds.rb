# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
@customer1 = FactoryBot.create(:customer)
@customer2 = FactoryBot.create(:customer)

@tea1 = FactoryBot.create(:tea, title: "Jasmin")
@tea2 = FactoryBot.create(:tea, title: "Green")
@tea3 = FactoryBot.create(:tea, title: "Black")
@tea4 = FactoryBot.create(:tea, title: "Earl Grey")


