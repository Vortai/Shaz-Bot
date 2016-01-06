# Shaz-Bot
A little mumble bot for making teams

## State
Currently Shaz-Bot works, but barely. It can connect, analyse users, and move them to pre-coded rooms which have currently been hard coded into it. It also can't guarantee that it will pick fat people. Furthermore it relies on code I hacked into its main dependency, the mumble-ruby library. However what it can do is pick people for teams, and then move them to rooms, and automatically update its database with mumble visible changes to a player (such as their name). In addition it can now be controlled in a limited fashion through the mumble server it is connected to.

## Plan
My roadmap currently involves several parts.

1. Get the database to a point where using the bot might actually be worth the time.
2. Implement the algorithm for ensuring no fats are left behind.
3. Make a .ini file general users can edit to better suit their own mumble situations.
4. Try and push my hack to the library dependency so users don't have to implement my hack by hand to actually use the bot.
5. Finally, making a way so the bot can be controlled through typed mumble commands from any whitelisted user, not just controlled through the computer of the bot's host.

Some pipe dreams include fleshing out my prototype skill select to better allow for personal role choice in players while still creating balanced teams and reducing the amount of hard coding found in the bot.

## Help
Currently the biggest help would be for players to either edit the HashStore.yml and then pushing it to the github or otherwise editing their entry and sending it to me.

## Install advice
So as this is a ruby program you obviously need ruby. First install the ruby gem of mumble-ruby and then navigate /home/$USER/.gem/ruby/2.3.0/gems/mumble-ruby-1.1.3/lib/mumble-ruby and make the following changes to the client.rb file. You'll also need to change your $PATH probably but there are better tutorials out there for that.

First below find_user put

```
def find_user_hash(hash)
	users.values.find { |h| h.hash == hash }
end

```

then near the move_user segment add

```
def move_user_hash(hash, channel)
	cid = channel_id channel
	uhid = user_session_hash hash
	send_user_state(session: uhid, channel_id: cid)
	channels[cid]
end
```

then in the private section of the file add

```
def user_session_hash(hash)
	hash = find_user_hash(hash) if hash.is_a? String
	id = hash.respond_to?(:session) ? hash.session : hash

	raise UserNotFound unless @users.has_key? id
	id
end
```
Rejoice! Shaz-Bot, now has a basic config file! All the user has to do is copy and rename config-sample.yml to config.yml and edit the dummy values to values that match their mumble.
