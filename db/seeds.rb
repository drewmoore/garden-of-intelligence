# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "faker"

def create_plan
    Plant.create(
        name: Faker::Food.vegetables,
        botanical_name: Faker::Lorem.sentence(word_count: 2),
        description: Faker::Food.description
    )
end

10.times { create_plan }