class Movie
  attr_accessor :title, :genre, :show_timings, :available_seats, :total_seats

  def initialize(title, genre, show_timings, total_seats)
    @title = title
    @genre = genre
    @show_timings = show_timings
    @available_seats = Array.new(show_timings.length) { Array.new(total_seats, true) }
    @total_seats = total_seats
  end

end


class User
  attr_accessor :name, :booked_tickets

  def initialize(name)
    @name = name
    @booked_tickets = []
  end

end

class TicketBookingSystem
  attr_accessor :movies, :users

  def initialize
    @movies = []
    @users = []
  end

  def add_user(name)
    user = User.new(name)
    users << user
    puts "#{name} added to the system."
  end

  def display_users
    puts "Registered Users:"
    users.each do |user|
      puts "#{user.name}"
      puts "---------------------"
    end
  end

  def book_ticket(user_index, movie_index, show_index)
    user = users[user_index]
    movie = movies[movie_index]
    show_time = movie.show_timings[show_index]

    available_seat = find_available_seat(movie, show_index)

    if available_seat
      movie.available_seats[show_index][available_seat[:number]-1] = false
      seat_number = available_seat[:number]
      user.booked_tickets << { movie: movie.title, show_time: show_time, seat_number: seat_number }
      puts "#{user.name}, booking confirmed for #{movie.title} at #{show_time}. Seat number: #{seat_number}"
    else
      puts "Sorry, no available seats for #{movie.title} at #{show_time}."
    end
  end

  def cancel_ticket(movie_index, show_index,seat_number)
    movie = movies[movie_index]
    show_time = movie.show_timings[show_index]

    if movie.available_seats[show_index][seat_number-1] == false
      movie.available_seats[show_index][seat_number-1] = true
      puts "Ticket canceled for #{movie.title} at #{show_time}."
    else
      puts "No tickets booked for #{movie.title} at #{show_time}."
    end
  end

  def find_available_seat(movie, show_index)
    movie.available_seats[show_index].each_with_index do |status, index|
      return { number: index + 1, status: status } if status
    end
    nil
  end
  
  def display_user_bookings(user_index)
    user = users[user_index]

    puts "#{user.name}'s Booked Tickets:"
    user.booked_tickets.each do |ticket|
      puts "Movie: #{ticket[:movie]}, Show Time: #{ticket[:show_time]}, Seat Number: #{ticket[:seat_number]}"
    end
    puts "---------------------"
  end

  def add_movie(title, genre, show_timings, total_seats)
    movie = Movie.new(title, genre, show_timings, total_seats)
    movies << movie
    puts "#{title} movie added to the system."
  end
  
  def display_movies
    puts "Available Movies:"
    movies.each do |movie|
      puts "#{movie.title} (#{movie.genre})"
      puts "Show Timings: #{movie.show_timings.join(', ')}"
      puts "Available seats: #{movie.available_seats}"
      puts "---------------------"
    end
  end

  def display_booking_status
    puts "Booking Status:"
    movies.each do |movie|
      puts "#{movie.title} (#{movie.genre})"
      movie.show_timings.each_with_index do |show_time, index|
        available_seats = movie.available_seats[index].count(true)
        booked_seats = movie.total_seats - available_seats
        puts "  - #{show_time}: Booked #{booked_seats}, Available #{available_seats}"
      end
      puts "---------------------"
    end
  end

end
    
# Example Usage:
ticket_system = TicketBookingSystem.new
ticket_system.add_user("John Doe")
ticket_system.add_user("Jane Doe")

ticket_system.add_movie("Inception", "Sci-Fi", ["10:00 AM", "2:00 PM", "6:00 PM"], 50)
ticket_system.add_movie("The Dark Knight", "Action", ["11:00 AM", "3:00 PM", "7:00 PM"], 40)

ticket_system.display_users

ticket_system.book_ticket(0, 0, 1)

ticket_system.cancel_ticket(0,1,1)
ticket_system.display_booking_status

ticket_system.display_user_bookings(0)
ticket_system.display_user_bookings(1)

ticket_system.display_movies
    
