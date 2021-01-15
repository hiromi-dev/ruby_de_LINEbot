# frozen_string_literal: true
require 'dotenv/load'

class LinebotController < ApplicationController
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  def callback

    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      # eventがユーザーからメッセージが送信された場合
      case event
      when Line::Bot::Event::Message
        #テキスト形式の場合
        case event.type
        when Line::Bot::Event::MessageType::Text
          case event.message['text']
          when /.*(会議|かいぎ).*/
            @meeting_url = ExecutionZoomApi.new.execution_zoom_api
            content = "ミーティング開始URL : #{@meeting_url['start_url'].slice(0..102)}"
          when /.*(あいうえお).*/
            content = "あいうえお"
          when /.*(かきくけこ).*/
            content = 'かきくけこ'
          else
            content = '違う'
          end
          message = {
              type: 'text',
              text: content
            }
        client.reply_message(event['replyToken'], message)
        # テキスト形式以外の場合
        when Line::Bot::Event::MessageType::Sticker
          message = {
            type: "template",
            altText: "this is a buttons template",
            template: {
              type: "buttons",
              title: "空いてる日程教えてよ",
              text: "Please select",
              actions: [
                {
                  type: "datetimepicker",
                  label: "いいよ",
                  mode: "date",
                  data: "action=datetemp&selectId=1"
                },
                {
                  type: "postback",
                  label: "やっぱりやめたい",
                  data: "action=cancel&selectId=2"
                },
              ]
            }
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
  end
end

class ExecutionZoomApi
  def execution_zoom_api
    uri = URI.parse(ENV['MEETING_URL'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.path)
    request['Authorization'] = "Bearer #{ENV['JWT']}"
    bearer = "Bearer #{ENV['JWT']}"
    request['Content-Type'] = 'application/json'
    request.body = {
                    "type":1,
                }.to_json
    response = http.request(request)
    url = JSON.parse(response.body)
  end
end
