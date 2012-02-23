# 3009_ContactUs
This is a bare bones contact page application which can be used
again in other projects.

Developed by Mat Harvard
[here](http://matharvard.ca/posts/2011/aug/22/contact-form-in-rails-3/)

This version uses gmail settings and config as described in [RailsApps
Project](http://railsapps.github.com/rails-heroku-tutorial.html)

Transcribed here by [Jim Noble](mailto:jimnoble@xjjz.co.uk) for [XJJZ
| designed communications](http://xjjz.co.uk)

## Configure
config/environments/production.rb

    config.action_mailer.default_url_options = { :host => 'myapp.heroku.com' }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default :charset => "utf-8"
    config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      domain: "myapp.heroku.com",
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: ENV["GMAIL_USERNAME"],
      password: ENV["GMAIL_PASSWORD"]
    }

## Set ENV vars
> heroku config:add GMAIL_USERNAME=no-reply@example.com GMAIL_PASSWORD=password

## Model
app/models/message.rb

    class Message

      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend  ActiveModel::Naming

      attr_accessor :name, :email, :subject, :body

      validates :name, :email, :subject, :body, :presence => true
      validates :email, :format => { :with => %r{.+@.+\..+} }, :allow_blank => true

      def initialize(attributes = {})
        attributes.each do |name, value|
          send("#{name}=", value)
        end
      end

      def persisted?
        false
      end

    end

## Mailer
app/mailers/notifications_mailer.rb

> rails g mailer NotificationsMailer

    class NotificationsMailer < ActionMailer::Base
      default from: "from@myapp.herokuapp.com"
      default   to: "you@youremail.co.uk"

      def new_message(message)
        @message = message
        mail(:subject => "[MyApp] #{message.subject}")
      end

    end

## Text message view
app/views/notifications_mailer/new_message.text.erb

    Name: <%= @message.name %>

    Email: <%= @message.email %>

    Subject: <%= @message.subject %>

    Body: <%= @message.body %>

## Controller
app/controllers/contact_controller.rb

    class ContactController < ApplicationController

      def new
        @message = Message.new
      end

      def create
        @message = Message.new(params[:message])

        if @message.valid?
          NotificationsMailer.new_message(@message).deliver
          redirect_to(contact_path, :notice => "Message was successfully sent.")
        else
          flash.now.alert = "Please fill all fields."
          render :new
        end

      end

    end

## Routes
config/routes.rb

    match 'contact' => 'contact#new',    :as => 'contact', :via => :get
    match 'contact' => 'contact#create', :as => 'contact', :via => :post

## View
app/views/contact/new.html.erb

    <%= form_for @message, :url => contact_path do |f| %>
      <table id="email">
        <tr>
          <td class="right"><%= f.label :name, "Your name:" %></td>
          <td><%= f.text_field :name %></td>
        </tr>
        <tr>
          <td class="right"><%= f.label :email %></td>
          <td><%= f.text_field :email %></td>
        </tr>
        <tr>
          <td class="right"><%= f.label :subject %></td>
          <td><%= f.text_field :subject %></td>
        </tr>
        <tr>
          <td colspan="2"><%= f.text_area :body %></td>
        </tr>
        <tr>
          <td colspan="2" class="shim"><%= f.submit "Send" %></td>
        </tr>
      </table>
    <% end %>


