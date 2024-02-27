require 'spec_helper'

class TestClass
  extend DoBlocks

  def no_blocks(x, y)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  def before_block(x, y)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_before :before_block do |args, kwargs|
    puts "About to call before_block(#{args.join(', ')})"
  end

  def after_block(x, y)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_after :after_block do |args, kwargs, result|
    puts "Result of after_block(#{args.join(', ')}) is #{result}"
  end

  def error_block(x, y)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_on_error :error_block, reraise: false do |args, kwargs, error|
    puts "Error calling error_block(#{args.join(', ')}): #{error}"
  end

  def all_blocks(x, y)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_before :all_blocks do |args, kwargs|
    puts "About to call all_blocks(#{args.join(', ')})"
  end

  do_after :all_blocks do |args, kwargs, result|
    puts "Result of all_blocks(#{args.join(', ')}) is #{result}"
  end

  do_on_error :all_blocks, reraise: false do |args, kwargs, error|
    puts "Error calling all_blocks(#{args.join(', ')}): #{error}"
  end

  def with_keyword_args(x:, y:)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_before :with_keyword_args do |args, kwargs|
    puts "About to call with_keyword_args(#{kwargs})"
  end

  do_after :with_keyword_args do |args, kwargs, result|
    puts "Result of with_keyword_args(#{kwargs}) is #{result}"
  end

  do_on_error :with_keyword_args, reraise: false do |args, kwargs, error|
    puts "Error calling with_keyword_args(#{kwargs}): #{error}"
  end

  def with_default_args(x, y = 1)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_before :with_default_args do |args, kwargs|
    puts "About to call with_default_args(#{args.join(', ')})"
  end

  do_after :with_default_args do |args, kwargs, result|
    puts "Result of with_default_args(#{args.join(', ')}) is #{result}"
  end

  do_on_error :with_default_args, reraise: false do |args, kwargs, error|
    puts "Error calling with_default_args(#{args.join(', ')}): #{error}"
  end

  def reraise_error(x, y)
    raise "Cannot divide by zero" if y == 0
    x / y
  end

  do_on_error :reraise_error do |args, kwargs, error|
    puts "Error calling reraise_error(#{args.join(', ')}): #{error}"
  end
end

RSpec.describe DoBlocks do
  describe '#do_before' do
    context 'when the method has no blocks' do
      it 'does not execute the block' do
        test_instance = TestClass.new
        expect { test_instance.no_blocks(3, 2) }.to_not output(/About to call before_block\(3, 2\)/).to_stdout
      end
    end

    context 'when the method has a before block' do
      it 'executes the block before the method' do
        test_instance = TestClass.new
        expect { test_instance.before_block(3, 2) }.to output(/About to call before_block\(3, 2\)/).to_stdout
      end
    end

    context 'when the method has all blocks' do
      it 'executes the block before the method' do
        test_instance = TestClass.new
        expect { test_instance.all_blocks(3, 2) }.to output(/About to call all_blocks\(3, 2\)/).to_stdout
      end
    end

    context 'when the method has keyword arguments' do
      it 'executes the block before the method' do
        test_instance = TestClass.new
        expect { test_instance.with_keyword_args(x: 3, y: 2) }.to output(/About to call with_keyword_args\(\{:x=>3, :y=>2\}\)/).to_stdout
      end
    end

    context 'when the method has default arguments' do
      it 'executes the block before the method' do
        test_instance = TestClass.new
        expect { test_instance.with_default_args(3) }.to output(/About to call with_default_args\(3\)/).to_stdout
      end
    end
  end

  describe '#do_after' do
    context 'when the method has no blocks' do
      it 'does not execute the block' do
        test_instance = TestClass.new
        expect { test_instance.no_blocks(3, 2) }.to_not output(/Result of after_block\(3, 2\) is 1/).to_stdout
      end
    end

    context 'when the method has an after block' do
      it 'executes the block after the method' do
        test_instance = TestClass.new
        expect { test_instance.after_block(3, 2) }.to output(/Result of after_block\(3, 2\) is 1/).to_stdout
      end
    end

    context 'when the method has all blocks' do
      it 'executes the block after the method' do
        test_instance = TestClass.new
        expect { test_instance.all_blocks(3, 2) }.to output(/Result of all_blocks\(3, 2\) is 1/).to_stdout
      end
    end

    context 'when the method has keyword arguments' do
      it 'executes the block after the method' do
        test_instance = TestClass.new
        expect { test_instance.with_keyword_args(x: 3, y: 2) }.to output(/Result of with_keyword_args\(\{:x=>3, :y=>2\}\) is 1/).to_stdout
      end
    end

    context 'when the method has default arguments' do
      it 'executes the block after the method' do
        test_instance = TestClass.new
        expect { test_instance.with_default_args(3) }.to output(/Result of with_default_args\(3\) is 3/).to_stdout
      end
    end
  end

  describe '#do_on_error' do
    context 'when the method has no blocks' do
      it 'raises the error' do
        test_instance = TestClass.new
        expect { test_instance.no_blocks(3, 0) }.to raise_error(/Cannot divide by zero/)
      end
    end

    context 'when the method has an error block' do
      it 'executes the block when an error occurs' do
        test_instance = TestClass.new
        expect { test_instance.error_block(3, 0) }.to output(/Error calling error_block\(3, 0\): Cannot divide by zero/).to_stdout
      end
    end

    context 'when the method has all blocks' do
      it 'executes the block when an error occurs' do
        test_instance = TestClass.new
        expect { test_instance.all_blocks(3, 0) }.to output(/Error calling all_blocks\(3, 0\): Cannot divide by zero/).to_stdout
      end
    end

    context 'when the method has keyword arguments' do
      it 'executes the block when an error occurs' do
        test_instance = TestClass.new
        expect { test_instance.with_keyword_args(x: 3, y: 0) }.to output(/Error calling with_keyword_args\(\{:x=>3, :y=>0\}\): Cannot divide by zero/).to_stdout
      end
    end

    context 'when the method has default arguments' do
      it 'executes the block when an error occurs' do
        test_instance = TestClass.new
        expect { test_instance.with_default_args(3, 0) }.to output(/Error calling with_default_args\(3, 0\): Cannot divide by zero/).to_stdout
      end
    end

    context 'when the method has an error block that reraises the error' do
      it 'executes the block when an error occurs and raises the error' do
        test_instance = TestClass.new
        expect { test_instance.reraise_error(3, 0) }
          .to raise_error(/Cannot divide by zero/)
          .and output(/Error calling reraise_error\(3, 0\): Cannot divide by zero/).to_stdout
      end
    end
  end
end
