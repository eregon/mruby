require './test/assert.rb'
Dir["test/t/*.rb"].sort.each { |test| require "./#{test}" }
require './test/report.rb'
