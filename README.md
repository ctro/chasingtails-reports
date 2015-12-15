ChasingTails Reports
====================

A simple web app for dog walkers using Rails and Postgres.

Development
===========

I just run this on my mac using `homebrew` and these tools:
- https://github.com/postmodern/chruby
- https://github.com/postmodern/ruby-install
- https://github.com/postmodern/gem_home

Something along the lines of:

Install rubies
```
brew install chruby
brew install ruby-install
brew install --HEAD https://raw.github.com/postmodern/gem_home/master/homebrew/gem_home.rb
gem update --system
ruby-install ruby:2.0.0
gem install bundler
```

Boot up the rails app
```
cd dev/chasingtails-reports
gem_home .
bundle
bundle exec rails s
```

Get a psql prompt
```
psql chasingtails_dev
\dt
\d users
select * from users;
```
