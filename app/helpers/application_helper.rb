module ApplicationHelper
	def admin (event)
		@user=User.find(event.admin_id)
	end
	def authenticate_user
  	unless current_user
	  redirect_to new_user_session_path
	end
  end
end