Gem::Specification.new do |s|
	s.name        = 'sloth'
	s.version     = '0.1'
	s.author      = 'katmagic'
	s.email       = 'the.magical.kat@gmail.com'
	s.homepage    = 'https://github.com/chloe/sloth'
	s.summary     = 'Lazily evaluate things.'
	s.description = 'Sloth makes laziness easy.'

	s.files = ['lib/sloth.rb', 'README.md']

	if ENV['GEM_SIG_KEY']
		s.signing_key = ENV['GEM_SIG_KEY']
		if ENV['GEM_CERT_CHAIN']
			s.cert_chain = ENV['GEM_CERT_CHAIN'].split(',')
		end
	else
		warn '$GEM_SIG_KEY unspecified; not signing gem'
	end
end
