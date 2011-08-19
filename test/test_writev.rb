require 'minitest/autorun'
require 'writev'
require 'tempfile'

class TestWritev < MiniTest::Unit::TestCase
  def test_writev
    file = Tempfile.new('foo')

    file.writev %w{ hello world }
    assert_equal 'helloworld', File.read(file.path)
    file.unlink
  end
end

# /* vim: set et sws=2 sw=2: */
