#!/bin/ruby

require "mumble-ruby"
require 'pp'
require 'yaml'

class Hash_Bot
    attr_accessor :cli

    def initialize
		@cli = Mumble::Client.new("mate.cheapmumble.com", "2032", "Hash-bot", "")
		@plrlist = {}
    end

	def hashGet
		hash_ln = @cli.users.count
		players = YAML.load_file('HashStore.yml')
		puts players[:"#{players.keys[2]}"][:playerSkills][:hof]
		for i in 0..hash_ln-1 do
			usrkey = @cli.users.keys[i]
			hshNm = @cli.users[usrkey].hash
			if players.include?(:"#{hshNm}") == true then
				puts @cli.users[usrkey].name
				puts @cli.users[usrkey].channel_id
				players[:"#{hshNm}"][:name] = @cli.users[usrkey].name
				total = 0
				for i in 0..6 do
					conConcKey = players[:"#{hshNm}"][:playerSkills].keys[i]
					total = total + players[:"#{hshNm}"][:playerSkills][:"#{conConcKey}"]
				end
				players[:"#{hshNm}"].merge!(:skillTotal => total)
			else
				defautPlayerSkills = {:hof => 2.0,:ld => 2.0,:gamesense => 3.0,:cap => 2.0,:fragging => 3.0,:offence => 4.0,:snipe => 1.0}
				tmpH = {:name => @cli.users[usrkey].name,:hash => @cli.users[usrkey].hash}
				tmpH.merge!(:playerSkills => defautPlayerSkills)
				pp (tmpH)
				players.merge!(:"#{hshNm}" => tmpH)
			end
			#make the feature that puts the usr into a hash
		end
		File.open('HashStore.yml','w') {|f1| f1.write(players.to_yaml)}
		#then here commit all those hashes to the players{} hash and save that to the hash file.
	end

	def onlinePlayers
		hash_ln = @cli.users.count
		onPlayers = {}
		for i in 0..hash_ln-1 do
			usrkey = @cli.users.keys[i]
			hshNm = @cli.users[usrkey].hash
			tmpH = {:hash => @cli.users[usrkey].hash}
			if @cli.users[usrkey].channel_id == 18 or @cli.users[usrkey].channel_id == 47 then
				tmpH.merge!(:fat => true)
				onPlayers.merge!(:"#{hshNm}" => tmpH)
			elsif @cli.users[usrkey].channel_id == 16 or @cli.users[usrkey].channel_id == 20 then
				tmpH.merge!(:fat => false)
				onPlayers.merge!(:"#{hshNm}" => tmpH)
			else
				tmpH.clear
			end
		end
		return onPlayers
	end

	def captainPick
		onPlayers = onlinePlayers()
		onplrsln = onPlayers.length
		playerSkillDB = YAML.load_file('HashStore.yml')
		for i in 0..onplrsln-1 do
			onPlayers[:"#{onPlayers.keys[i]}"].merge!(:playerSkills => playerSkillDB[:"#{onPlayers.keys[i]}"][:playerSkills])
			onPlayers[:"#{onPlayers.keys[i]}"].merge!(:skillTotal => playerSkillDB[:"#{onPlayers.keys[i]}"][:skillTotal])
		end
		pp (onPlayers)
		@plrlist = onPlayers
		#File.open('snktest.yml', 'w') {|f1| f1.write(onPlayers.to_yaml)}
	end
	
	def randPick
		onPlayers = onlinePlayers()
		playerSkillDB = YAML.load_file('HashStore.yml')
		teamBE = {}
		teamDS = {}
		for i in 0..((onPlayers.length-1)/2) do
			rndPick = rand(onPlayers.length)
			puts rndPick
			teamBE.merge!(:"#{i}" => onPlayers.delete(:"#{onPlayers.keys[rndPick]}"))
		end
		puts teamBE
	end

	# use (x..y).to_a to make a range for their skill value
	# the skill ranges will be created in a manner that accounts for both the players individual skill and total skill.
	# the formula I have in mind, while a bit arbitrary is totalskill/individualskill*100
	# then put those skill values into a hash for each player, ergo :player1 => 1-10, :player2 => 11-30, etc
	# then use rand(max) to make a number inside that range
	# then use hash[:player"#{i}"].include?(randomNumber) to find the player who gets picked
	def skillSelect(team, role, severity)
		
	end


end

hashbot = Hash_Bot.new
hashbot.cli.connect
sleep(2)
# hashbot.cli.join_channel(4)
hashbot.hashGet
# hashbot.onlinePlayers
 hashbot.captainPick
# hashbot.randPick

