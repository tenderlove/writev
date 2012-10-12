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

  def test_checks_arguments
    file = Tempfile.new('foo')

    assert_raises TypeError do
      file.writev('hello')
    end
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

  def test_list_too_long
    file = Tempfile.new('foo')
    assert_raises(ArgumentError) do
      file.writev %w{ x } * (IO::IOV_MAX + 1)
    end
  end
end

# /* vim: set et sws=2 sw=2: */
