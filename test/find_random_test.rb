require 'test_helper'

class User < ActiveRecord::Base
end

class FindRandomTest < Test::Unit::TestCase
  fixtures :users
  
  def test_size_of_found_collection
    assert_equal 4, User.random(4).size
  end

  def test_found_collection_random
    srand(14)
    rand_users = User.random(3)
    assert_equal 'matilda', rand_users[0].login
    assert_equal 'silvia', rand_users[1].login
    assert_equal 'leon', rand_users[2].login
  end
end
