#!/usr/bin/env ruby

require 'rubygems'
require 'rubygems/command'

def fix_summary(summary)
    if summary[-1] == '.'
        return summary[0..-2]
    else
        return summary
    end
end

gem = ARGV[0]
version = ARGV[1] if ARGV[1]

specs = []
if version != nil
    dep = Gem::Dependency.new gem, version
else
    dep = Gem::Dependency.new gem
end
puts "Downloading metadata for Gem '#{gem}'..."
sp = Gem::SpecFetcher.fetcher.fetch dep, true
specs.push(*sp.map { |spec,| spec })
if specs.empty?
    puts "Gem '#{gem}' not found at RubyGems.org"
    exit
end

dir = "rubygem-#{gem}"
raise "Directory already exists" if Dir::exists?(dir)
Dir::mkdir(dir)
Dir::chdir(dir)

s = specs.last
puts "Found #{gem} version #{s.version}"
puts "Creating Makefile..."
File.open('Makefile', 'w') do |f|
    f.puts '# Created by: XXX <foo@bar.com>'
    f.puts '# $FreeBSD$'
    f.puts
    f.puts "PORTNAME=\t#{s.name}"
    f.puts "PORTVERSION=\t#{s.version}"
    f.puts "CATEGORIES=\trubygems CATEGORY"
    f.puts "MASTER_SITES=\tRG"
    f.puts
    f.puts "MAINTAINER=\truby@FreeBSD.org"
    f.puts "COMMENT=\t%s" % fix_summary(s.summary)
    f.puts
    f.print "LICENSE=\t"
    if s.license
        f.puts s.license
    elsif not s.licenses.empty?
        s.licenses.each do |l|
            f.print "%s " % l
        end
    else
        f.puts "????"
    end
    f.puts
    first = true
    s.dependencies.each do |d|
        d.requirement.requirements.each do |r|
            version = r[1]
        end
        if first == true
            f.print "RUN_DEPENDS=\t"
            first = false
        else
            f.print "\t\t"
        end
        f.puts "rubygem-#{d.name}>=#{version}:${PORTSDIR}/CATEGORY/rubygem-#{d.name}"
    end
    f.puts "USE_RUBY=\tyes"
    f.puts "USE_RUBYGEMS=\tyes"
    f.puts "RUBYGEM_AUTOPLIST=yes"
    f.puts
    f.puts "PLIST_FILES="
    f.puts
    f.puts ".include <bsd.port.mk>"
end

puts "Creating pkg-descr..."
File.open('pkg-descr', 'w') do |f|
    f.puts s.description
    f.puts
    f.puts "WWW: %s" % s.homepage
end

puts "Port generation complete in directory #{dir}"
