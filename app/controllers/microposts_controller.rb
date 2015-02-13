class MicropostsController < ApplicationController


before_filter :signed_in_user
 
def create
end

def destroy
end


# private

	# def micropost_params
	# 	#specify required params and those permitted, all others restricted to prevent csrf
	# 	params.require(:micropost).permit(:content)
	# end	

end
