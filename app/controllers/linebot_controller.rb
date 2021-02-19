# frozen_string_literal: true
require 'dotenv/load'
require 'pry'

require_relative 'get_zoom_meeting_url.rb'

class LinebotController < ApplicationController
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  def callback

    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      # eventがユーザーからメッセージが送信された場合
      case event
      when Line::Bot::Event::Postback
        LineBot::PostbackEvent.send(event['postback']['data'])

      when Line::Bot::Event::Message
        case event.type
        #テキスト形式の場合
        when Line::Bot::Event::MessageType::Text
          case event.message['text']
          when /.*(会議|かいぎ).*/
            @meeting_url = ExecutionZoomApi.new.get_zoom_meeting_url
            content = "ミーティング開始URLを作成しました。 : #{@meeting_url['start_url'].slice(0..102)}"
            message = {
              type: 'text',
              text: content
            }
            client.reply_message(event['replyToken'], message)
          when /.*(選択).*/
            selectdate = {
            type: "template",
            altText: "this is a buttons template",
            template: {
              type: "buttons",
              title: "予約したい日付を指定して下さい。",
              text: "Please select",
              actions: [
                {
                  type: "datetimepicker",
                  label: "選択",
                  mode: "datetime",
                  data: "action=datetemp&selectId=1"
                },
                {
                  type: "postback",
                  label: "指定しない",
                  data: "action=datetemp&selectId=1"
                },
              ]
            }
          }
            client.reply_message(event['replyToken'], selectdate)
          else
            content = '違う'
            message = {
              type: 'text',
              text: content
            }
            client.reply_message(event['replyToken'], message)
          end

        # スタンプの場合
        when Line::Bot::Event::MessageType::Sticker
          @selectdate = {
            type: "template",
            altText: "this is a buttons template",
            template: {
              type: "buttons",
              title: "予約したい日付を指定して下さい。",
              text: "Please select",
              actions: [
                {
                  type: "datetimepicker",
                  label: "選択",
                  mode: "datetime",
                  data: "action=datetemp&selectId=1"
                },
                {
                  type: "postback",
                  label: "指定しない",
                  data: "action=cancel&selectId=2"
                },
              ]
            }
          }
          client.reply_message(event['replyToken'], @selectdate)

        end
      end
    end

    head :ok
  end

end
