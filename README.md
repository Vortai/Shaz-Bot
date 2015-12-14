# Shaz-Bot
A little mumble bot for making teams

## State
Currently Shaz-Bot works, but barely. It can connect, analyse users and move them to pre-coded rooms that have currently been hard coded into it. It also can't guarantee that it will pick fat people and due to the very sorry state of the database it uses to get player skill values, the teams it picks are good on luck alone. Furthermore it relies on code I hacked into its main dependency, the mumble-ruby library. However what it can do is pick people for teams, and then move them to rooms, and automatically update its database with mumble visable changes to a player (such as their name).

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
