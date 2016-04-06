class SolarSystemsController < ApplicationController
  def list
    @systems = SolarSystem.all
  	respond_to do |format|  
    	format.html
    	format.json { render :json =>{:results => @systems.to_json(only: [:system_id, :name]) }}
  	end
  end
end
