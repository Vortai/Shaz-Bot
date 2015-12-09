#!/bin/ruby

require "mumble-ruby"

class Shaz_Bot
	attr_accessor :cli
	
	def initialize
		@cli = Mumble::Client.new("mate.cheapmumble.com", "2032", "Shaz-bot", "")
	end

	def get_username_from_id(id)
		@cli.users[id].name
	end

	def get_channel_from_id(id)
		@cli.users[id].channel_id
	end

	def get_hash_from_id(id)
		@cli.users[id].hash
	end

	def return_to_pugs
		i = 0
		hash_ln = @cli.users.count
		for i in 0..hash_ln-1 do
			userkey = @cli.users.keys[i]
			if @cli.users[userkey].channel_id == 21 or @cli.users[userkey].channel_id == 22
				@cli.move_user(userkey,16)
			end
		end
	end

	def name_hash_get
		i = 0
		hash_ln = @cli.users.count
		usr_str = ""
		for i in 0..hash_ln-1 do
			usrkey = @cli.users.keys[i]
			usr_str << get_username_from_id(usrkey)
			usr_str << "|"
			usr_str << get_hash_from_id(usrkey).to_s
			usr_str << "\n"
		end
		puts usr_str
		File.open('Shaz-Bot-Alias.txt','a') do |f1|
			f1. << usr_str[0..-2]
		end

	end

	def name_room_get
		i = 0
		hash_ln = @cli.users.count
		usr_str = ""
		usr_str_apn = ""
		for i in 0..hash_ln-1 do
			usrkey = @cli.users.keys[i]
			usr_str_apn << get_username_from_id(usrkey)
			usr_str_apn << ","
			if get_channel_from_id(usrkey) == 18 then
				usr_str_apn << "1\n"
			elsif get_channel_from_id(usrkey) == 16 or get_channel_from_id(usrkey) == 20 then
				usr_str_apn << "0\n"
			else
				usr_str_apn.clear
			end
			usr_str << usr_str_apn.downcase
			usr_str_apn.clear
		end
		File.open('UserList.plist','w') do |f1|
		    f1. << usr_str[0..-2]
		end
	end

	def edit_user_list
		File.open('UserList.plist','w') do |f1|
			f1 << @cli.name_room_get[0..-2]
		end
	end

	def sort_teams
		system 'python2.7 TeamPickBotInterface.py picked.pug UserList.plist AUTribesPlayers.ini AUTribesPlayerAliases.txt'
	end

# I'm going to try and make this a function which recives input and moves people to the specified Room
	def team_move(teamnm,room)
		i = 0
		outputpug = File.open('picked.pug','r')
		outputal = File.open('Shaz-Bot-Alias.txt','r')
		contents = outputpug.read
		p_alias = outputal.read
		puts contents[/#{teamnm}.*$/i]
		contents[/#{teamnm}.*$/i] 
		team = contents[/#{teamnm}.*$/i]
		teamA = team[/(?<=\|).*/]
		teamA = teamA.split(',')
		for i in 0..6 do
			puts i
			puts teamA[i]
			puts p_alias[/(?<=#{teamA[i]}\|).*/i]
			if teamA[i] == p_alias[/#{teamA[i]}.*?(?=\|)/i].downcase then
				@cli.move_user_hash(p_alias[/(?<=#{teamA[i]}\|).*/i],room)
				puts "player moved"
			end
			sleep(1)
		end
	end
end

#	if name == alias[/#{name}.*?(?=\|)/i].downcase then
#		@cli.move_user_hash(alias[/(?<=#{name}\|).*/i],room)
#	end

shazbot = Shaz_Bot.new
shazbot.cli.connect
sleep(2)
shazbot.cli.join_channel(41)
shazbot.name_room_get
shazbot.sort_teams
shazbot.name_hash_get
#shazbot.return_to_pugs
shazbot.team_move("BE",21)
shazbot.team_move("DS",22)
#x = shazbot.cli.find_user('Martyw')
#shazbot.cli.move_user_hash(x,16)

=begin
cli=Mumble::Client.new("mate.cheapmumble.com", "2032", "Shaz-Bot", "")

def say_to_current_channel(text)
	say_to_channel(current_channel, text)
end

def say_to_channel(channel, text)
	@cli.text_channel(channel, text)
	rescue
	puts "ERROR: Failed to message channel with ID of #{channel}. Invalid channel?"
	return 1
end


cli.connect
sleep(2)
cli.join_channel(41)


test = cli.users
test2 = test.inspect
Hash_ln = test.count
i = 0
Nm_Str = String.new
Nm_Str_Apn = String.new
Nm_Str_Hsh = String.new

cli.on_text_message do |msg|
	if msg.message == 'return to pugs'
		i1 = 0
		for i1 in 1..Hash_ln do
			hashnm1 = cli.users.keys[i1]
			hashnmx = cli.users[hashnm1].channel_id
			hashnmN = cli.users[hashnm1].name
			puts hashnmx
			puts hashnmN
			if hashnmx == 21 or hashnmx == 22
				cli.move_user(hashnmN,16)
			end
		end
	cli.disconnect
	else msg.message == 'move on'
		puts "moving on"
	end
end
sleep(1)
puts "press enter to end script"
gets



for i in 1..Hash_ln do
	want = test2.slice!(/name=(.*?) channe/m)
	Nm_Str_Apn << want[5..-8]
	Nm_Str_Hsh << want[5..-8]
	Nm_Str_Apn << ","
	Nm_Str_Hsh << "|"
	puts Nm_Str_Apn
	want = test2.slice!(/l_id=(.*?) /m)
	puts want
	if want[5..-2].eql? "18" then
		Nm_Str_Apn << "1\n"
	elsif want[5..-2].eql? "16" or want[5..-2].eql? "20" then
		Nm_Str_Apn << "0\n"
	else
		puts "not a pugger"
		Nm_Str_Apn.clear
	end
	Nm_Str << Nm_Str_Apn.downcase
	Nm_Str_Apn.clear
	want = test2.slice!(/hash=(.*?) /m)
	Nm_Str_Hsh << want[5..-2]
	Nm_Str_Hsh << "\n" 
end
puts "-------------"
puts Nm_Str
puts "-------------"


File.open('UserList.plist','w') do |f1|
	f1. << Nm_Str[0..-2]
end

File.open('Shaz-Bot-Alias.txt','a') do |f2|
		f2. << "\n"
        f2. << Nm_Str_Hsh[0..-2]
end

system 'python2.7 TeamPickBotInterface.py picked.pug UserList.plist AUTribesPlayers.ini AUTribesPlayerAliases.txt'

output = File.open('picked.pug','r')
contents = output.read
Contents_Stack = contents.slice!(/Stack(.*?)\n/m)
Contents_Frag = contents.slice!(/Frag(.*?)\n/m)
cli.text_channel(16,contents)
cli.text_channel(18,contents)
#cli.text_channel(18,"YOU WOT M8'S I'LL REK YA, SKYNET COMES NOW")
#Contents_BE = contents.slice!(/BE(.*?)\n/m).split(',')
#Contents_DS = contents.split(',')

puts "-------------"
puts Contents_Stack
puts "-------------"
puts Contents_Frag
puts "-------------"
puts Contents_BE
puts "-------------"
puts Contents_DS
puts "-------------"

puts Contents_BE[1]
BE = 1
for BE in 1..6 do
	MovePl = Contents_BE[BE]
	puts MovePl
	cli.move_user(MovePl,21)
end

#Design plan, my bot takes the picked.pug file and grabs the names of the people, then from there it uses the alias file to get their hash key. Then what happens is that my bot uses that hash key to find the username of the corresponding with that hash, then issues the move command to that user.


#contents.gsub!(',',"\n")
cli.disconnect
=end
