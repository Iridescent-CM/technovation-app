## This controller uses includes

class JumpController < ApplicationController
  include Wicked::Wizard
  steps :first, :second, :last_step

  def show
    skip_step(params[:skip_step_options]) if params[:skip_step]
    jump_to :last_step, params[:skip_step_options] if params[:jump_to]
    if params[:resource]
      value = params[:resource][:save] == 'true'
      @bar  = Bar.new(value)
      render_wizard(@bar)
    else
      render_wizard
    end
  end

  def update
  end

end
