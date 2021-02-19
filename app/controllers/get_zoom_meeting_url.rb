require 'dotenv/load'
require 'net/https'
require 'net/http'
require 'uri'
require 'json'

class ExecutionZoomApi

  def initialize
    @jwt='jwt'
    @user_id='user_id'
    @meeting_url='meeting_url'
  end

  def genarate_jwt_token
    payload = {
                iss: ENV['API_KEY'],
                exp: Time.now.to_i + 4 * 3600
            }
    secret  = ENV['SECRET']
    token = JWT.encode payload, secret, 'HS256'
    return token
  end

  def get_user_data(jwt)
    uri = URI.parse("https://api.zoom.us/v2/users")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer" + jwt
    req_options = {
                use_ssl: uri.scheme == "https",
            }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end
    result = JSON.parse(response.body)
    return result["users"][0]["id"].to_s
  end

  def get_zoom_meeting_url
    @jwt = self.genarate_jwt_token
    @user_id=self.get_user_data(@jwt)
    @meeting_url = "https://api.zoom.us/v2/users/#{@user_id}/meetings"

    uri = URI.parse(@meeting_url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.path)
    request['Authorization'] = "Bearer #{@jwt}"
    bearer = "Bearer #{@jwt}"

    request['Content-Type'] = 'application/json'
    request.body = {
                    "type":1,
                }.to_json
    response = http.request(request)
    url = JSON.parse(response.body)
  end
end
