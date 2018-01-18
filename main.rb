require 'sinatra'
require 'sinatra/reloader'
require_relative 'db_config'
require_relative 'models/photographer'
require_relative 'models/comment'
require_relative 'models/user'

enable :sessions

helpers do 
	def current_user
		User.find_by(id: session[:user_id])
	end
	def loggen_in?
		!!current_user		
	end
end

get '/' do
	@photographers = Photographer.all 
	erb :index
end
get '/about' do
	erb :about
end
# get '/recent' do
# 	@photographers = Photographer.all 
# 	erb :recent
# end
# get '/photographers/top4' do
# 	erb :recent
# end
get '/search' do
	@photographers = Photographer.where("name LIKE ?", "%#{params[:photographer_name]}%")
		# Foo.where("bar LIKE ?", "%#{query}%")
  	# conn = PG.connect(dbname: 'ratemyphotographer')
 	# resp = conn.excu()
	# conn.closese
	# end
	erb :search_result
end

get '/photographers/new' do
	 if session[:user_id] 	
	erb :new
	 else 
	 	redirect '/'
	 end
end

# add a new photographer to photographers table
post '/photographers' do
	photographer = Photographer.new
	photographer.name = params[:name]
	photographer.image_url = params[:image_url]
	photographer.phone = params[:phone]
	photographer.address = params[:address]
	photographer.website = params[:website]
	photographer.created_by = session[:user_id]
	photographer.created_at = params[:created_at]
	photographer.rate=0
	photographer.save
	redirect '/'
end


get '/photographers/:id' do
	@photographer = Photographer.find(params[:id])
	@comments = Comment.where(photographer_id: params[:id])
	erb :show
end

get '/photographers/:id/edit' do
	@photographer = Photographer.find(params[:id])
	erb :edit
end

put '/photographers/:id' do
	photographer = Photographer.find(params[:id]) #is this because missing @ front?
	photographer.name = params[:name]
	photographer.image_url = params[:image_url]
	photographer.phone = params[:phone]
	photographer.address = params[:address]
	photographer.website = params[:website]
	photographer.created_by = session[:user_id]
	photographer.created_at = params[:created_at]
	photographer.save
	redirect '/photographers/'+ photographer.id.to_s
end

post '/comments' do
	comment = Comment.new
	comment.content = params[:content]
	comment.photographer_id = params[:photographer_id]
	comment.created_by = session[:user_id]
	comment.created_at = params[:created_at]
	comment.rate = params[:rate]
	comment.save
	
	comments = Comment.where(photographer_id: params[:photographer_id])
	total = 0
	comments.each do |comment|
		total += comment.rate 
	end
	avg = total / comments.count

	photographer = Photographer.find(params[:photographer_id])
	photographer.rate = avg
	photographer.save
	redirect "/photographers/#{comment.photographer_id}" 
end

post '/rate' do

	redirect "/photographers/#{comment.photographer_id}"
end

delete '/photographers/:id' do	
	photographer = Photographer.find(params[:id])
	comments = Comment.where(photographer_id: params[:id])
	
	comments.each do |comment|
	comment.destroy
	end

	photographer.destroy
	redirect '/'
end

get '/signup' do
	erb :signup
end

post '/signup' do
	user = User.new
	user.name = params[:name]
	user.email = params[:email]
	user.password = params[:password]
	user.save
	session[:user_id] = user.id
	redirect '/'
end

get '/session' do
	redirect '/'
	end

post '/session' do
	user = User.find_by(email:params[:email])

	if user && user.authenticate(params[:password])
		session[:user_id] = user.id 
		redirect '/' 
	else
		session[:user_id] = nil
		redirect '/' 
	end
end

delete '/session' do
	session[:user_id] = nil
	redirect '/'
end








