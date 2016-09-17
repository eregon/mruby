[Array, Exception, String, Hash].each do |m|
  m.class_exec do
    public :initialize, :initialize_copy
  end
end

class Float
  def << n
    to_i << n
  end
  def >> n
    to_i >> n
  end
end

module Enumerable
  alias _detect detect
  def detect(ifnone = nil, &block)
    adapted = ifnone
    adapted = -> { ifnone } if ifnone and !ifnone.respond_to?(:call)
    _detect(adapted, &block)
  end
  alias find detect
end

class Exception
  alias _inspect inspect
  def inspect
    _inspect.sub(/\A#</, '').sub(/>\z/, '')
  end

  alias _backtrace backtrace
  def backtrace
    b = _backtrace
    def b.first
      self[0].sub(/`block \(\d+ levels\) in <top \(required\)>'/, 'Object.call')
    end
    b
  end
end

module Mrbtest
  FIXNUM_MIN = -(1 << 62)
  FIXNUM_MAX = (1 << 62) - 1
end

class << GC
  attr_accessor :interval_ratio, :step_ratio, :generational_mode
end

class NoMethodError
  alias _message message
  def message
    _message.sub(/:\w+\z/, '').tr('`', "'")
  end
end

class Bignum
  def class
    Float
  end
end

class String
  alias _include? include?
  def include?(str)
    str = str.chr if Fixnum === str
    _include?(str)
  end

  alias _inspect inspect
  def inspect
    _inspect.gsub(/\\u0(\d{3})/, '\\\\\1')
  end
end

class Fixnum
  def / other
    to_f / other
  end
end
