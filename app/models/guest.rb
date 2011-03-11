class Guest < Hobo::Guest

  def administrator?
    false
  end
  
	def supervisor_of
		return []
	end
	
	def manager_of
		return []
	end	

end
