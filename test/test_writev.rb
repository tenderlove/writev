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

  def test_length
    file = Tempfile.new('foo')

    assert_equal 'helloworld'.bytesize, file.writev(%w{ hello world })
    file.unlink
  end

  def test_fail
    File.open(__FILE__, 'r') do |f|
      assert_raises(IOError) do
        f.writev %w{ hello world }
      end
    end
  end
end

# /* vim: set et sws=2 sw=2: */
