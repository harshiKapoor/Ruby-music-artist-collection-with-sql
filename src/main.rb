module Main

	require_relative 'Artist'
	require_relative 'DatabaseUtils'
	require 'json'

	$data_array = []



	def self.artist_menu
		resp = print_index()
		choices(resp)
		puts "Wish to continue (Y/N)?"
		cont = gets.chomp
		while cont == 'Y'
			resp = print_index()
			choices(resp)
			puts "Wish to continue (Y/N)?"
			cont = gets.chomp
		end
	end



	def self.print_index
		puts "WELCOME TO OUR SONG AND ARTIST COLLECTION FINDER"
		puts "================================================"
		puts "please select an action"
		puts "------------------------------------------------"
		puts "1. Add an artist to collection"
		puts "2. Print all artists in my collection"
		puts "3. Search for artist in our collection"
		puts "4. How many artists in my collection"
		puts "5. Find Number of songs sung by an artist"
		puts "6. Delete a record"
		puts "7. Update total songs in artist record"
		puts "8. Add another popular song by artist"
		resp = gets.chomp
		resp
	end



	def self.choices(resp)

		case resp
		when"1"
			add_new_artist()
		when"2"
			all_artist()
		when "3"
			find_artist()
		when"4"
			how_many_artists_in_my_collection()
		when"5"
			number_of_songs_by_artist()
		when"6"
			delete_a_record()
		when"7"
			update_total_songs()
		when"8"
			add_to_most_popular_song()
		else
			"please make valid choices"
		end
		
	end




	def self.add_new_artist
		collection = []
		artist = Artist.new
		add_artist(artist)
		hash = {}
		artist.instance_variables.each {|var| hash[var.to_s.delete("@")] = artist.instance_variable_get(var) }
		validate_input(hash)
	end



	def self.validate_input(hash)
		valid_name = false
		valid_age = false
		valid_totalSongs = false


		# file = File.read(filename)
		# data_array = UTILS.parse_JSON(filename)

		validated_hash = {}

		validated_hash[:name] = hash['name'].downcase
		if validated_hash[:name].match('[a-zA-Z]+')
			valid_name = true
		else
			puts "name must contain alphabets only"
			valid_name = false
		end


		if hash['age'].match('^[0-9]*$')
			validated_hash[:age] = hash['age']
			valid_age = true
		else
			puts "age can only contain numbers"
			valid_age = false
		end


		if hash['total_songs'].match('^[0-9]*$')
			validated_hash[:total_songs ] = hash['total_songs']
			valid_totalSongs = true
		else
			puts "total songs can only contain numbers"
			valid_totalSongs = false
		end

		if hash['most_popular_songs']
			validated_hash[:most_popular_songs] = hash['most_popular_songs']
		end


		if valid_name == true && valid_age == true && valid_totalSongs == true
			 DatabaseUtils.write_to_db_table(validated_hash)
		else
			puts "invalid input , data not updated"
		end

	end




	def self.find_artist()
		artist_name = DatabaseUtils.user_input_for_artist_name
		record = DatabaseUtils.find_an_artist(artist_name.downcase)
		puts "here is the record we found for your search #{artist_name}"
		record.each do |r|
			puts "| #{r['name']} | #{r['age']} | #{r['totalSongs'] }| #{r['popularSongs']} |"
		end
	end


	def self.how_many_artists_in_my_collection()
		res = DatabaseUtils.number_of_artists
		puts "we have found #{res.count} records"
	end


	def self.all_artist()
		puts "================================================================================================="
		records = DatabaseUtils.print_all_artists()
		puts "NAME   | AGE  | TOTAL SONGS | POPULAR SONGS                   |"
		records.each do |record|
			puts "#{record['name']} | #{record['age']} | #{record['totalSongs']} | #{record['popularSongs']}"
		end
		puts "================================================================================================="
	end


	def self.number_of_songs_by_artist()
		artist_name = DatabaseUtils.user_input_for_artist_name
		res = DatabaseUtils.number_of_songs_by_artist(artist_name.downcase)
		res.each do |r|
			puts "Number of songs sung by #{artist_name} is #{r['totalSongs']} "
		end
	end


	def self.delete_a_record()
		artist_name = DatabaseUtils.user_input_for_artist_name
		DatabaseUtils.delete_a_record(artist_name.downcase)
		all_artist()
	end



	def self.update_total_songs()
		artist_name = DatabaseUtils.user_input_for_artist_name
		puts "give me new total songs by #{artist_name}"
		totalSongs = gets.chomp
		DatabaseUtils.update_totalSongs_by_artist(artist_name.downcase, totalSongs)

		res = DatabaseUtils.number_of_songs_by_artist(artist_name.downcase)
		res.each do |r|
			puts "Number of songs sung by #{artist_name} is updated and is now #{r['totalSongs']} "
		end
	end


	def self.add_to_most_popular_song()
		artist_name = DatabaseUtils.user_input_for_artist_name
		puts "give me new popular songs by #{artist_name}"
		popularSong = gets.chomp

		res = DatabaseUtils.update_popularSongs_by_artist(artist_name.downcase, popularSong)
	
	end


	def self.add_artist(artist)

		puts "Name of artist.."
		artist.name = gets.chomp
			
		puts "Age.."
		artist.age = gets.chomp

		puts "Total Songs .."
		artist.total_songs = gets.chomp

		puts "Most popular songs.."
		artist.most_popular_songs << gets.chomp
		puts "Do you have more popular songs to add (Y/N) "
		response = gets.chomp
		while response == "Y"
			puts "ok add more.."
			artist.most_popular_songs << gets.chomp
			puts "Do you have more popular songs to add (Y/N) "
			response = gets.chomp
		end
	end



end





