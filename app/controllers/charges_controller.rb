class ChargesController < ApplicationController

  def new
  end

  def create
    # mock of params received from the order sent from the product page
    params = {
      charge: {
        amount: 500,
        description: 'Rails Stripe customer',
        order_id: 1
      }
    }
    # Amount in cents
    @amount = params[:charge][:amount]
    # @user.user_id = current_user.id
    @description = params[:charge][:description]
    @order_id = params[:charge][:order_id]
    charge_success = false

    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => params[:charge][:description],
        :currency    => 'usd'
      )
      # .on_success(&-> {
      #   puts "good"
      # })
      # .on_failure(&-> {
      #   puts "bad"
      # })



      # toggle whether card payment success or not

    rescue Stripe::CardError => e
      # The card has been declined
      flash[:error] = e.message
      redirect_to new_charge_path
    ensure
      if charge_success
        # if payment processed on the card then save transaction to db
        @payment = Payment.new
        @payment.payment_date = Time.now
        @payment.order_id =
        @payment.total_amount = @amount
        @payment.description = @description

        render 'create'
      end
    end
  end
end
