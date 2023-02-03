ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  def log_in_as(user)
    session[:user_id] = user.id
  end

  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def login_path
    '/api/login'
  end

  def log_in_as(user, password: 'password')
    post login_path, params: { email: user.email, password: password }
  end



  def assert_lte(a, b)
    assert_operator a, :<=, b
  end

end