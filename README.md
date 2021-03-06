# Workon

Wouldn't it be nice if you could just cd into your project directory and type "workon" in order to get your work on? I'd rather do that than type "r s", open a new terminal tab, type "bundle exec guard", then go to my browser and open the home page, find the project on my issue tracker, etc. That's what this project does.

## Installation

Add this line to your application's Gemfile:

   	gem 'workon_rails', group: :development
	
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install workon_rails


The first time you run workon from your project root, it creates a .workon file with default configuration.

## Usage

Start your project for editing:

	$ workon

Set your editor to RubyMine. Any valid editor command will do.

	$ workon set editor=mine
	
Show configuration:

	$ workon config
	
Tell workon what page to open in the browser to start your project:

	$ workon set domain=mysite.test

OPTIONAL: Set your Pivotal Tracker project ID:

	$ workon set tracker_id=TRACKER_ID
	
OPTIONAL: Set your GitHub repo so that Workon can open it in the browser. OPTIONAL

	$ workon set github=singlebrook/swidjit
	
OPTIONAL: Set the URL of your ActiveCollab installation and your project name. Get the project name by going to your project in ActiveCollab and copying the part of the URL that comes after /projects/.
	
	$ workon set ac_url=support.gorges.us
	$ workon set ac=my-project-name
	
OPTIONAL: Tell Workon to move the project windows. Depends on SizeUp.

	$ workon set move_windows=yes : 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## DESIRED CHANGES

I don't actually use the SizeUp window positioning. It would be nice if somebody made that work and added the ability to configure where your windows open using the config vars.

Also the default browser is Google Chrome. That's good enough for me. If you want it to use Firefox, I'm open to a pull request.

## CREDITS

I didn't actually start this project. Leon Miller-Out of Singlebrook did. My starting point, his code, can be found here:

https://gist.github.com/sbleon/3439856

I simply took those shell scripts and fronted them with a Ruby script that sets configuration options and environment variables before triggering Leon's scripts. I also added some of my own stuff and made the scripts friendly to the new environment variables.

Thanks Leon!
