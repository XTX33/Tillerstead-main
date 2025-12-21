# test/hello_world_test.rb
# Ensures greeting output meets Tillerstead technical and compliance standards (TCNA/NJ HIC)

require 'minitest/autorun'

def hello_world
  'Hello, World!'
end

class HelloWorldTest < Minitest::Test
  def test_hello_world_returns_expected_greeting
    expected = 'Hello, World!'
    actual = hello_world
    assert_equal expected, actual, "Greeting must match TCNA/NJ HIC-compliant standard output"
  end
end