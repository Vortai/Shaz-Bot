#!/bin/ruby

require 'pp'
require 'yaml'


class Sort_Players
	attr_accessor :srt

	def initialize
		@srt = ()
		@roleList = {:role1 => :hof, :role2 => :cap, :role3 => :ld, :role4 => :snipe, :role5 => :offence, :role6 => :offence, :role7 => :offence}
	end

	def hashEditTest
		teamBloodEagle = {}
		teamDiamondSword = {}
		playeryml = YAML.load_file('snktest.yml')
		for i in 0..@roleList.length-1 do
			inp = (smplSelect("BE", @roleList[:"role#{i+1}"], 4, playeryml))
			teamBloodEagle[:"#{@roleList.keys[i]}"] = inp
			puts "The number of entries left in the player list = #{playeryml.length}"
		end
		pp teamBloodEagle
#		playeryml.delete(smplSelect("BE", :offence, 7, playeryml))
#		playeryml.delete(smplSelect("BE", :ld, 7, playeryml))
	end

	def smplSelect(team, role, severity, playerlist)
		plrPK = {}
		numPK = {}
#		pp plryml = (playerlist.sort_by {|k, v| v[:playerSkills][:"#{role}"]}.reverse!.to_h).sort_by {|k, v| v[:playerSkills][:"#{role}"]}.reverse!.to_h
	 	plryml = (playerlist.sort_by {|k, v| v[:playerSkills][:"#{role}"]}.reverse!.to_h).sort_by {|k, v| v[:playerSkills][:"#{role}"]}.reverse!.to_h
		for i in 0..severity-1 do
			plryml[:"#{plryml.keys[i]}"][:"#{role}AVG"] = (plryml[:"#{plryml.keys[i]}"][:playerSkills][:"#{role}"]*(plryml[:"#{plryml.keys[i]}"][:playerSkills][:"#{role}"]/plryml[:"#{plryml.keys[i]}"][:skillTotal])*10).round
		end
#		pp playerlist.length
#		pp plryml.length
		for i in 0..severity-1 do
			plrPK[:"player#{i}"] = (plryml[:"#{plryml.keys[i]}"][:playerSkills][:"#{role}"]*(plryml[:"#{plryml.keys[i]}"][:playerSkills][:"#{role}"]/plryml[:"#{plryml.keys[i]}"][:skillTotal])*10).round
		end
#		pp plrPK
		for i in 0..severity-1 do
#			puts "this is loop #{i}"
			if i == 0 then
				numPK[:"player#{i}"] = (0..plrPK[:"player#{i}"]).to_a
#				puts numPK[:"player#{i}"] = (0..plrPK[:"player#{i}"]).to_a
			else
				numPK[:"player#{i}"] = (numPK[:"player#{i-1}"].max+1..plrPK[:"player#{i}"]+numPK[:"player#{i-1}"].max).to_a
#				puts numPK[:"player#{i}"] = (numPK[:"player#{i-1}"].last+1..plrPK[:"player#{i}"]+numPK[:"player#{i-1}"].last).to_a
			end	
		end
		pp numPK
		rndNUM = rand(numPK.values.flatten.max)
		pp rndNUM
		for i in 0..severity-1 do
			if numPK[:"player#{i}"].include?(rndNUM) then
				puts "player#{i} picked for #{team}'s #{role}"
				puts playerlist[:"#{playerlist.keys[i]}"][:hash]
				return playerlist.delete(:"#{playerlist.keys[i]}")
			end
		end
	end

end

plrSort = Sort_Players.new
plrSort.hashEditTest()
#plrSort.smplSelect("BE", :offence, 7 )
