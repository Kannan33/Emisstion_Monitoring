# frozen_string_literal: true
class ApplicationController < ActionController::Base
  layout :set_layout

  private

  def set_layout
    if user_signed_in?
      _layout = 'application'
    elsif rto_officer_signed_in?
      _layout = 'rto_officer'
    end
  end
end
