require 'pg'
require 'active_record'

options = {
	adapter: 'postgresql',
	database: 'ratemyphotographer',
}

ActiveRecord::Base.establish_connection(options)