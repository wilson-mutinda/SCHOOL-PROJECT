class Api::V1::UsersController < ApplicationController
  # create_user
  def create_user
    begin
      # user_params
      # email_param
      email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
      if email_param.blank?
        render json: { errors: { email: "Email is required!"}}, status: :unprocessable_entity
        return
      else
        # email_format
        email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        unless email_param.match?(email_format)
          render json: { errors: { email: "Invalid email format!"}}, status: :unprocessable_entity
          return
        end

        # email should not exist
        existing_email = User.find_by(email: email_param)
        if existing_email
          render json: { errors: { email: "Email already exists!"}}, status: :unprocessable_entity
          return
        end
        email_param = email_param.to_s.gsub(/\s+/, '').downcase
      end

      # phone_param
      phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
      if phone_param.blank?
        render json: { errors: { phone: "Phone is required!"}}, status: :unprocessable_entity
        return
      else
        if phone_param.match?(/\A07\d{8}\z/)
          phone_param = phone_param.sub(/\A07/, '2547')
        elsif phone_param.match?(/\A01\d{8}\z/)
          phone_param = phone_param.sub(/\A01/, '2541')
        end
        # phone_format
        phone_format = /\A(2541|2547)\d{8}\z/
        unless phone_param.match?(phone_format)
          render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
          return
        end

        # phone should not exist
        existing_phone = User.find_by(phone: phone_param)
        if existing_phone
          render json: { errors: { phone: "Phone already exists!"}}, status: :unprocessable_entity
          return
        end

        phone_param = phone_param.to_s.gsub(/\s+/, '')
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password]
      password_confirmation_param = user_params[:password_confirmation]

      if password_param.present? || password_confirmation_param.present?
        if password_param.present? && !password_confirmation_param
          render json: { errors: { password_confirmation: "PAssword confirmation is required!"}}, status: :unprocessable_entity
          return
        elsif !password_param && password_confirmation_param.present?
          render json: { errors: { password: "PAssword is required!"}}, status: :unprocessable_entity
          return
        end

        if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
          render json: { errors: { password_confirmation: "PAssword Mismatch!"}}, status: :unprocessable_entity
          return
        end

        if password_param.length < 8
          render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
          return
        end

        unless password_param.match?(/[A-Za-z]/) && password_param.match?(/\d/)
          render json: { errors: { password: "Password should have both numbers and digits!"}}, status: :unprocessable_entity
          return
        end

        password_param = password_param
        password_confirmation_param = password_confirmation_param
      end

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param,
        flag: "Admin"
      )
      if created_user
        render json: { message: "User created successfully!" }, status: :created
      else
        render json: { error: "Error creating user!", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e 
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
    
  end

  # view single_user
    def single_user
      begin
        user = User.find_by(id: params[:id])
        if user
          info = user.as_json(except: [:created_at, :updated_at, :password_digest])
          render json: info, status: :ok
        else
          render json: { error: "User not found!"}, status: :not_found
        end
      rescue => e
        render json: { error: "Something wenbt wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # view all_users
    def all_users
      begin
        users = User.all
        if users.empty?
          render json: { error: "Empty List!" }, status: :not_found
          return
        else
          info = users.map do |user|
            user.as_json(except: [:created_at, :updated_at, :password_digest])
          end
          render json: info, status: :ok
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # update_user
    def update_user
      begin
        user = User.find_by(id: params[:id])
        if user
          updated_user_info = {}

          # email_param
          email_param = user_params[:email].to_s.gsub(/\s+/, '').downcase
          if email_param.present?
            # email_format
            email_format = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
            unless email_param.match?(email_format)
              render json: { errors: { email: "Invalid email format!"}}, status: :unprocessable_entity
              return
            end

            # email should not exist
            existing_email = User.find_by(email: email_param)
            if existing_email && existing_email.id != user.id
              render json: { errors: { email: "Email already exists!"}}, status: :unprocessable_entity
              return
            end

            updated_user_info[:email] = email_param.to_s.gsub(/\s+/, '').downcase
          end

          # phone_param
          phone_param = user_params[:phone].to_s.gsub(/\s+/, '')
          if phone_param.present?

            if phone_param.match?(/\A07\d{8}\z/)
              phone_param = phone_param.sub(/\A07/, '2547')
            elsif phone_param.match?(/\A01\d{8}\z/)
              phone_param = phone_param.sub(/\A01/, '2541')
            end

            # phone_format
            phone_format = /\A(2541|2547)\d{8}\z/
            unless phone_param.match?(phone_format)
              render json: { errors: { phone: "Invalid phone format!"}}, status: :unprocessable_entity
              return
            end

            # phone should not exist
            existing_phone = User.find_by(phone: phone_param)
            if existing_phone && existing_phone.id != user.id
              render json: { errors: { phone: "Phone already exists!"}}, status: :unprocessable_entity
              return
            end
            updated_user_info[:phone] = phone_param.gsub(/\s+/, '').to_s
          end

          # password_param and password_confirmation_param
          password_param = user_params[:password]
          password_confirmation_param = user_params[:password_confirmation]

          if password_param.present? || password_confirmation_param.present?
            if password_param.present? && !password_confirmation_param
              render json: { errors: { password_confirmation: "PAssword confirmation is required!"}}, status: :unprocessable_entity
              return
            elsif !password_param && password_confirmation_param.present?
              render json: { errors: { password: "PAssword is required!"}}, status: :unprocessable_entity
              return
            end

            if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
              render json: { errors: { password_confirmation: "PAssword Mismatch!"}}, status: :unprocessable_entity
              return
            end

            if password_param.length < 8
              render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
              return
            end

            unless password_param.match?(/[A-Za-z]/) && password_param.match?(/\d/)
              render json: { errors: { password: "Password should have both numbers and digits!"}}, status: :unprocessable_entity
              return
            end

            password_param = password_param
            password_confirmation_param = password_confirmation_param

            updated_user_info[:password] = password_param
            updated_user_info[:password_confirmation] = password_confirmation_param
          end

          # update_user
          updated_user = User.update(
            updated_user_info
          )

          if updated_user
            render json: { message: "User updated successfully!"}, status: :ok
          else
            render json: { error: "Error updating user!", info: updated_user.errors.full_messages }, status: :unprocessable_entity
          end

        else
          render json: { error: "User not found!"}, status: :not_found
           return
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # delete_user
    def delete_user
      begin
        user = User.find_by(id: params[:id])
        if user
          email = user.email
          phone = user.phone
          user.destroy
          render json: { message: "User of #{email} and #{phone} has been deleted successfully!"}, status: :ok
        else
          render json: { error: "User not found!"}, status: :not_found
          return
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # user_login
    def user_login
      begin
        email_param = params[:email].to_s.gsub(/\s+/, '').downcase
        password_param = params[:password]

        if email_param.present? || password_param.present?
          if email_param.present? && !password_param
            render json: { errors: { password: "Password is required!"}}, status: :unprocessable_entity
            return
          elsif !email_param && password_param.present?
            render json: { errors: { email: "Email is required!"}}, status: :unprocessable_entity
            return
          end
        end
        
        user = User.find_by(email: email_param)
        if user
          auth = user.authenticate(password_param)
          if auth

            access_token = JsonWebToken.new.encode_token(user.id, user.flag, 30.minutes.from_now)
            refresh_token = JsonWebToken.new.encode_token(user.id, user.flag, 24.hours.from_now)

            flag = user.flag.downcase

            UserMailer.welcome_email(user).deliver_now

            render json: { 

              message: "Login Successful!",
              access_token: access_token,
              refresh_token: refresh_token,
              flag: flag

            }, status: :ok
          else
            render json: { errors: { password: "Invalid password for '#{email_param}'"}}, status: :unprocessable_entity
            return
          end
        else
          render json: { errors: { email: "Email not found!"}}, status: :not_found
          return
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # forgot_password
    def forgot_password
      begin
        email_param = params[:email].to_s.gsub(/\s+/, '').downcase
        if email_param.blank?
          render json: { errors: { email: "Email is required!"}}, status: :unprocessable_entity
          return
        end

        user = User.find_by(email: email_param)
        if user
          token = SecureRandom.hex(10)
          current_time = Time.now.utc

          user.update(
            reset_password_token: token,
            reset_password_sent_at: current_time
          )

          # send email to user
          UserMailer.forgot_password_email(user, token).deliver_now
          render json: { message: "Updated token and token time on backend!", token: token}, status: :ok
        else
          render json: { errors: { email: "User not found!"}}, status: :not_found
          return
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # reset_password
    def reset_password
      begin
        token_param = params[:token]
        password_param = params[:password]
        password_confirmation_param = params[:password_confirmation]

        user = User.find_by(reset_password_token: token_param)
        if user
          if password_param.present? || password_confirmation_param.present?
            if password_param.present? && !password_confirmation_param
              render json: { errors: { password_confirmation: "Password consfirmation is required!"}}, status: :unprocessable_entity
              return
            elsif password_confirmation_param.present? && !password_param
              render json: { errors: { password: "Password is required!"}}, status: :unprocessable_entity
              return
            end

            if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
              render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
              return
            end

            if password_param.length < 8
              render json: { errors: { password: "Password should have at least 8 characters!"}}, status: :unprocessable_entity
              return
            end

            unless password_param.match?(/[A-Za-z]/) && password_param.match?(/\d/)
              render json: { errors: { password: "Password should have both digits and letters!"}}, status: :unprocessable_entity
              return
            end
          end

          user.update(
            password: password_param,
            password_confirmation: password_confirmation_param,
            reset_password_token: nil,
            reset_password_sent_at: nil
          )
          render json: { message: "User password updated succesfully!"}, status: :ok
        else
          render json: { error: "User not found!"}, status: :not_found
          return
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # refresh_token
    def refresh_token
      begin
        headers = request.headers['Authorization']
        token = headers.split(' ').last
        decoded = JsonWebToken.new.decode_token(token)

        user_flag = decoded[:flag]
        user_id = decoded[:user_id]
        exp = decoded[:exp]

        new_access_token = JsonWebToken.new.encode_token(user_id, user_flag, 30.minutes.from_now)
        new_refresh_token = JsonWebToken.new.encode_token(user_id, user_flag, 24.hours.from_now)

        render json: {
          message: "Token decoded successfully!",
          user_flag: user_flag,
          user_id: user_id,
          exp: exp,
          new_access_token: new_access_token,
          new_refresh_token: new_refresh_token

        }, status: :ok
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
      end
      
    end

    # google_login
    require 'httparty'

    def google_login
      token = params[:token]

      begin
        user_info = HTTParty.get(
          "https://www.googleapis.com/oauth2/v3/userinfo",
          headers: { "Authorization" => "Bearer #{token}" }
        )

        if user_info.code == 200
          email = user_info['email']
          name  = user_info['name']

          user = User.find_or_create_by(email: email) do |u|
            u.name = name
            u.password = SecureRandom.hex(10)
            u.flag = "User"   # make sure you set flag, otherwise token creation may fail
          end

          access_token  = JsonWebToken.new.encode_token(user.id, user.flag, 30.minutes.from_now)
          refresh_token = JsonWebToken.new.encode_token(user.id, user.flag, 24.hours.from_now)

          render json: {
            message: "Google Login Successful!",
            access_token: access_token,
            refresh_token: refresh_token,
            user: user
          }, status: :ok
        else
          render json: { error: "Invalid Google token" }, status: :unauthorized
        end
      rescue => e
        render json: { error: "Something went wrong!", message: e.message }, status: :unauthorized
      end
    end


  # privately hold user_params
  private
  def user_params
    params.require(:user).permit(:email, :phone, :flag, :password, :password_confirmation)
  end
end
