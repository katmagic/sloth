Sloth
=====

Sloth is a Ruby gem that implements the `lazy()` function as robustly as
possible.

Installation
------------

	gem install sloth

Usage
-----

	require 'sloth'
	obj = lazy{:sloth}
	obj.to_s # => 'sloth'

Hunting Sloths
--------------

Sloths can only (easily) be detected by the `sloth?` method.

	sloth = lazy{:sloth}

	sloth.sloth?       # => true
	sloth.class        # => Symbol
	:sloth.sloth?      # => false
	sloth.is_a?(Sloth) # => false
	Sloth === sloth    # => false

The `evaluated?` method can tell whether a Sloth has been evaluated.

	sloth = lazy{'sloth'}

	sloth.evaluated? # => false
	"lazy #{sloth}s"
	sloth.evaluated? # => true

nil and false
-------------

Unfortunately, Ruby doesn't provide any easy way to override the behavior of if,
so

	if lazy{false}
		puts('fail')
	else
		puts('success')
	end

will `puts('fail')`. A workaround has been implemented via the `self()` method,
which has been defined on `Object`. Therefore,

	if lazy{false}.self
		puts('fail')
	else
		puts('success')
	end

will `puts('success')`.

License
-------

Sloth is in the public domain.
