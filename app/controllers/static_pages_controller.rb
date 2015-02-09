class StaticPagesController < ApplicationController
  
  def home
  end

  def help
  end

  def about
  end

  def contacts
  end

  def books
  end

  def what
  	#remap to contacts (route must exist)
  	#render action: :contacts
  	# render action: :help
  	# render html: "<b> joels rendered html</b>".html_safe
	# render :js => "alert('hello')"
  	# render :text => "<strong>Not Found</strong>".html_safe, :layout => true
  	render :text => "<strong> Uh oh...Not found</strong>", :status => 404, :layout => true
  	# render plain: "ok"
  	
  end

end
