require 'net/http'
require 'json'

class TicketSeedsController < ApplicationController
  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    @ticket_prices = {}
    uhoh = []

    begin
      gameid = params[:gameurl].match(/([0-9]{2,})\/?$/)[1] 
    rescue => e
      flash[:error] = "Could not parse URL"
      respond_to do |format|
        format.html { render :action => "new" }
      end
      return
    end
    json = Net::HTTP.get(URI("http://www.stubhub.com/ticketAPI/restSvc/event/#{gameid}/sort/price/0"))
    response = JSON.parse(json)

    response["eventTicketListing"]["eventTicket"].each{|t|
      if t["zn"].nil?
        uhoh << t
        next
      end

      integer_price = (t["cp"]*100).to_i
      if !@ticket_prices[t["zn"]] || @ticket_prices[t["zn"]] > integer_price
        @ticket_prices[t["zn"]] = integer_price
      end
    }

    respond_to do |format|
      format.html
    end
  end
end
