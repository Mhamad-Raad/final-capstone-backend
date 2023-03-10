# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb
User.create(name: "John Doe", email: "john@example.com", password: "password123")
Trip.create(price: 100, rating: 5, destination_city: "New York", description: "A trip to New York", user_id: 1)
Reservation.create(date: "2021-02-25", time: "12:00", departure_city: "San Francisco", user_id: 1, trip_id: 1)