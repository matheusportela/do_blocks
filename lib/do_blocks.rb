module DoBlocks
  def do_before(method_name, &block)
    original_method = instance_method(method_name)

    define_method(method_name) do |*args, **kwargs|
      block.call(args, kwargs)
      original_method.bind(self).call(*args, **kwargs)
    end
  end

  def do_after(method_name, &block)
    original_method = instance_method(method_name)

    define_method(method_name) do |*args, **kwargs|
      result = original_method.bind(self).call(*args, **kwargs)
      block.call(args, kwargs, result)
      result
    end
  end

  def do_on_error(method_name, reraise: true, &block)
    original_method = instance_method(method_name)

    define_method(method_name) do |*args, **kwargs|
      begin
        original_method.bind(self).call(*args, **kwargs)
      rescue => error
        block.call(args, kwargs, error)
        raise error if reraise
      end
    end
  end
end
