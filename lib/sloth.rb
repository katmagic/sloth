# A Sloth is just a wrapper to lazily evaluate an object. A Sloth will behave
# just like the result of the given block except in the case of if statements,
# where a Sloth object will always evaluate to true, and when the initialize()
# function is called.
class Sloth < BasicObject
	def initialize(&block)
		raise(LocalJumpError, 'no block given') unless block
		@block = block
	end

	def method_missing(name, *args, &block)
		unless defined?(@object)
			@object = @block.call()
			@block = nil
		end

		begin
			begin
				@object.public_send(name, *args, &block)
			rescue ::NoMethodError => _ex_
				if _ex_.backtrace[0].start_with?(__FILE__)
					# If @object doesn't respond to public_send(), try using __send__().
					@object.__send__(name, *args, &block)
				else
					::Kernel.raise(_ex_)
				end
			end
		rescue ::Exception => _ex_
			# Remove evidence of ourself from the traceback.
			_ex_.backtrace.reject!{|line| line.start_with?(__FILE__)}
			::Kernel.raise(_ex_)
		end
	end

	instance_methods.each do |method_name|
		next if [:method_missing, :initialize].include?(method_name)

		define_method(method_name) do |*args, &block|
			method_missing(method_name, *args, &block)
		end
	end

	# sloth? will return true for Sloth instances and false for everything else.
	# This is basically the only way to tell if something is a Sloth.
	def sloth?
		true
	end

	# This is true iff we have already been evaluated.
	def evaluated?
		defined?(@object)
	end
end

class Object
	# Return self.
	def self
		self
	end

	# sloth? will return true for Sloth instances and false for everything else.
	# This is basically the only way to tell if something is a Sloth.
	def sloth?
		false
	end
end

class Class
	alias :__original_equals_equals_equals, :===

	# Redefine ===() so that it will operate properly on Sloth instances.
	def ===(obj)
		__original_equals_equals_equals(obj.instance_eval{self})
	end
end

module Kernel
	# Return a Sloth initialized with the given block.
	def lazy(&block)
		Sloth.new(&block)
	end
end
