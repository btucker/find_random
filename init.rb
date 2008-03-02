require File.dirname(__FILE__) + '/lib/find_random'
ActiveRecord::Base.send :include, GreenRiver::FindRandom
