class ApplicationController < ActionController::Base

  if RtoOfficer.signed_in?
    layout 'rto_officer'
  else
    layout 'application'
  end
end
