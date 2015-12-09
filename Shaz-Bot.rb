#!/bin/ruby

require 'mumble-ruby'
require 'pp'
require 'yaml'

class Shaz_Bot
	attr_accessor :cli

	def initialize
		@cli = Mumble::Client.new("mate.cheapmumble.com","2032","Shaz-Bot","")
		@roleList = {:role1 => :hof, :role2 => :cap, :role3 => :ld, :role4 => :snipe, :role5 => :offence, :role6 => :offence, :role7 => :offence}
	end

	def hashYmlUpdate
		players = YAML.load_file('HashStore.yml')
        for i in 0..@cli.users.count-1 do
            usrkey = @cli.users.keys[i]
            hshNm = @cli.users[usrkey].hash
            if players.include?(:"#{hshNm}") == true then
                puts "the players current name is #{@cli.users[usrkey].name}"
                puts "the channel id is #{@cli.users[usrkey].channel_id}"
                players[:"#{hshNm}"][:name] = @cli.users[usrkey].name
                total = 0
                for i in 0..6 do
                    roleName = players[:"#{hshNm}"][:playerSkills].keys[i]
                    total = total + players[:"#{hshNm}"][:playerSkills][:"#{roleName}"]
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
        File.open('HashStore.yml','w') {|f1| f1.write(players.to_yaml)} #then here commit all those hashes to the players{} hash and save that to the hash file.
    end	

	def onlinePlayers
        onPlayers = {}
        for i in 0..@cli.users.count-1 do
            usrkey = @cli.users.keys[i]
            hshNm = @cli.users[usrkey].hash
            tmpH = {:hash => @cli.users[usrkey].hash}
            if @cli.users[usrkey].channel_id == 81 or @cli.users[usrkey].channel_id == 102 then
                tmpH.merge!(:fat => true)
                onPlayers.merge!(:"#{hshNm}" => tmpH)
            elsif @cli.users[usrkey].channel_id == 79 or @cli.users[usrkey].channel_id == 85 then
                tmpH.merge!(:fat => false)
                onPlayers.merge!(:"#{hshNm}" => tmpH)
            else
                tmpH.clear
            end
        end
        return onPlayers
    end

	def btrOnlinePlayers
		onPlayers = {}
		for i in 0..@cli.users.count-1 do
			usrkey = @cli.users.keys[i]
			hshNm = @cli.users[usrkey].hash
			if @cli.users[usrkey].channel_id == 81 or @cli.users[usrkey].channel_id == 102 then
				onPlayers.merge!(:"#{hshNm}" => true)
			elsif @cli.users[usrkey].channel_id == 79 or @cli.users[usrkey].channel_id == 85 then
				onPlayers.merge!(:"#{hshNm}" => false)
			end
		end
		return onPlayers
	end

	def teamMove(teamHash, room)
		for i in 0..teamHash.length-1 do
			@cli.move_user_hash(teamHash[teamHash.keys[i]][:hash],room) # this calls a function in the mumble-ruby library which moves users via their hash
			sleep(1) # sleep just because it makes the movement look nicer :D
		end
	end

	def teamCompositionGet
		teamBE = {}
		teamDS = {}
		playeryml = YAML.load_file('HashStore.yml')
		onlinePlayerList = onlinePlayers()
		btrOnlinePlayerList = btrOnlinePlayers()
		pp btrOnlinePlayerList
		puts btrOnlinePlayerList.key(true)
		for i in 0..@roleList.length-1 do
			playerSelected = simpleSelect("BE", @roleList[:"role#{i+1}"], 3, onlinePlayerList)
			teamBE[:"#{@roleList.keys[i]}"] = playerSelected
		end
		for i in 0..@roleList.length-1 do
			playerSelected = simpleSelect("DS", @roleList[:"role#{i+1}"], 3, onlinePlayerList)
			teamDS[:"#{@roleList.keys[i]}"] = playerSelected
		end
		while onlinePlayerList.has_value?(true) do # this loop is used to first check for any fat people not picked
			puts "the missed fat check worked"
			puts onlinePlayerList.key(true)
			break
		end
=begin
		pp teamBE
		pp teamDS
		teamMove(teamBE, 82)
		teamMove(teamDS, 83)
=end
	end

	def simpleSelect(team, role, severity, playerlist)
		skillyml = {}
		playerDataList = YAML.load_file('HashStore.yml')
		for i in 0..playerlist.length-1 do
			skillyml[:"#{playerlist.keys[i]}"] = (playerDataList[:"#{playerlist.keys[i]}"][:playerSkills][:"#{role}"]*(playerDataList[:"#{playerlist.keys[i]}"][:playerSkills][:"#{role}"]/playerDataList[:"#{playerlist.keys[i]}"][:skillTotal])*10).round
		end
		skillyml = skillyml.sort_by {|k, v| -v}[0..severity].to_h
		for i in 0..skillyml.length-1 do
			if i == 0 then
				skillyml[skillyml.keys[i]] = (0..skillyml[:"#{skillyml.keys[i]}"]-1).to_a
			else
				skillyml[skillyml.keys[i]] = (skillyml[:"#{skillyml.keys[i-1]}"].max+1..skillyml[:"#{skillyml.keys[i]}"]+skillyml[:"#{skillyml.keys[i-1]}"].max).to_a
			end
		end
		randomNumber = rand(skillyml.values.flatten.max)
		for i in 0..skillyml.length-1 do
			if skillyml[:"#{skillyml.keys[i]}"].include?(randomNumber) then
				puts "#{skillyml.keys[i]} picked for the role"
				return playerlist.delete(:"#{skillyml.keys[i]}")
			end
		end
	end
end

shazbot = Shaz_Bot.new
shazbot.cli.connect
sleep(2)
shazbot.hashYmlUpdate
#shazbot.onlinePlayers
shazbot.teamCompositionGet
