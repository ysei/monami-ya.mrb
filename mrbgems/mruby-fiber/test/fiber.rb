assert('Fiber.new') {
  f = Fiber.new{}
  f.class == Fiber
}

assert('Fiber#resume') {
  f = Fiber.new{|x| x == 2}
  f.resume(2)
}

assert('Fiber#transfer') do
  f2 = nil
  f1 = Fiber.new do |v|
    Fiber.yield v
    f2.transfer
  end
  f2 = Fiber.new do
    f1.transfer(1)
    f1.transfer(1)
    Fiber.yield 2
  end
  assert_equal 1, f2.resume
  assert_raise(FiberError) { f2.resume }
  assert_equal 2, f2.transfer
  assert_raise(FiberError) { f1.resume }
  f1.transfer
  f2.resume
  assert_false f1.alive?
  assert_false f2.alive?
end

assert('Fiber#alive?') {
  f = Fiber.new{ Fiber.yield }
  f.resume
  r1 = f.alive?
  f.resume
  r2 = f.alive?
  r1 == true and r2 == false
}

assert('Fiber#==') do
  root = Fiber.current
  assert_equal root, root
  assert_equal root, Fiber.current
  assert_false root != Fiber.current
  f = Fiber.new {
    assert_false root == Fiber.current
  }
  f.resume
  assert_false f == root
  assert_true f != root
end

assert('Fiber.yield') {
  f = Fiber.new{|x| Fiber.yield(x == 3)}
  f.resume(3)
}

assert('FiberError') do
  assert_equal StandardError, FiberError.superclass
end

assert('Fiber iteration') {
  f1 = Fiber.new{
    [1,2,3].each{|x| Fiber.yield(x)}
  }
  f2 = Fiber.new{
    [9,8,7].each{|x| Fiber.yield(x)}
  }
  a = []
  3.times {
    a << f1.resume
    a << f2.resume
  }
  a == [1,9,2,8,3,7]
}

assert('Fiber with splat in the block argument list') {
  Fiber.new{|*x|x}.resume(1) == [1]
}

assert('Fiber raises on resume when dead') do
  assert_raise(FiberError) do
    f = Fiber.new{}
    f.resume
    assert_false f.alive?
    f.resume
  end
end

assert('Yield raises when called on root fiber') do
  assert_raise(FiberError) { Fiber.yield }
end

assert('Double resume of Fiber') do
  f1 = Fiber.new {}
  f2 = Fiber.new {
    f1.resume
    assert_raise(FiberError) { f2.resume }
    Fiber.yield 0
  }
  assert_equal 0, f2.resume
  f2.resume
  assert_false f1.alive?
  assert_false f2.alive?
end

assert('Recursive resume of Fiber') do
  f1, f2 = nil, nil
  f1 = Fiber.new { assert_raise(FiberError) { f2.resume } }
  f2 = Fiber.new {
    f1.resume
    Fiber.yield 0
  }
  f3 = Fiber.new {
    f2.resume
  }
  assert_equal 0, f3.resume
  f2.resume
  assert_false f1.alive?
  assert_false f2.alive?
  assert_false f3.alive?
end

assert('Root fiber resume') do
  root = Fiber.current
  assert_raise(FiberError) { root.resume }
  f = Fiber.new {
    assert_raise(FiberError) { root.resume }
  }
  f.resume
  assert_false f.alive?
end

assert('Fiber without block') do
  assert_raise(ArgumentError) { Fiber.new }
end


assert('Transfer to self.') do
  result = []
  f = Fiber.new { result << :start; f.transfer; result << :end  }
  f.transfer
  assert_equal [:start, :end], result

  result = []
  f = Fiber.new { result << :start; f.transfer; result << :end  }
  f.resume
  assert_equal [:start, :end], result
end

assert('Resume transferred fiber') do
  f = Fiber.new {
    assert_raise(FiberError) { f.resume }
  }
  f.transfer
end

assert('Root fiber transfer.') do
  result = nil
  root = Fiber.current
  f = Fiber.new {
    result = :ok
    root.transfer
  }
  f.resume
  assert_true f.alive?
  assert_equal :ok, result
end

assert('Break nested fiber with root fiber transfer') do
  root = Fiber.current

  result = nil
  f2 = nil
  f1 = Fiber.new {
    Fiber.yield f2.resume
    result = :f1
  }
  f2 = Fiber.new {
    result = :to_root
    root.transfer :from_f2
    result = :f2
  }
  assert_equal :from_f2, f1.resume
  assert_equal :to_root, result
  assert_equal :f2, f2.transfer
  assert_equal :f2, result
  assert_false f2.alive?
  assert_equal :f1, f1.resume
  assert_equal :f1, result
  assert_false f1.alive?
end

assert('CRuby Fiber#transfer test.') do
  ary = []
  f2 = nil
  f1 = Fiber.new{
    ary << f2.transfer(:foo)
    :ok
  }
  f2 = Fiber.new{
    ary << f1.transfer(:baz)
    :ng
  }
  assert_equal :ok, f1.transfer
  assert_equal [:baz], ary
end
