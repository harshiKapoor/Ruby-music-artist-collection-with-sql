module DatabaseUtils

	require 'mysql2'

	$conn  = Mysql2::Client.new(:host => 'localhost',
                           :database => 'harshi_test_db',
                           :username => 'root', 
                           :flags    => Mysql2::Client::MULTI_STATEMENTS)

	def self.write_to_db_table(validated_hash)
		name = validated_hash[:name]
		age = validated_hash[:age]
		total_songs = validated_hash[:total_songs]
		most_popular_songs = validated_hash[:most_popular_songs]
		rs = $conn.query("INSERT INTO artists(name, age, totalSongs, popularSongs) VALUES('#{name}','#{age}','#{total_songs}','#{most_popular_songs}')")			
	end


	def self.find_an_artist(artist_to_find)
		rs = $conn.query( "SELECT * FROM artists WHERE name = '#{artist_to_find}'")
	end

	def self.number_of_artists()
		rs = $conn.query( "SELECT COUNT(*) FROM artists")
	end

	def self.print_all_artists()
		rs = $conn.query("SELECT * FROM artists")
	end

	def self.number_of_songs_by_artist(artist_name)
		rs = $conn.query("SELECT totalSongs FROM artists WHERE name = '#{artist_name}'")
	end

	def self.delete_a_record(artist_name)
		rs = $conn.query( " DELETE FROM artists WHERE name = '#{artist_name}' ")
	end

	def self.update_totalSongs_by_artist(artist_name, new_total_songs)
		rs = $conn.query ( "UPDATE artists SET totalSongs = '#{new_total_songs}' WHERE name = '#{artist_name}'")
	end

	def self.update_popularSongs_by_artist(artist_name,new_popular_song)
		rs = $conn.query ( "UPDATE artists SET popularSongs = '#{new_popular_song}' WHERE name = '#{artist_name}'")
	end


	def self.user_input_for_artist_name
		puts "give me name of artist.."
		artist_name = gets.chomp
		artist_name.downcase
	end




end
