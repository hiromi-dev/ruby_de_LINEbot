# frozen_string_literal: true

class PostsController < ApplicationController
  require 'line/bot' # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: [:callback]

  def client
    @client ||= Line::Bot::Client.new do |config|
      config
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def callback
    # Postモデルの中身をランダムで@postに格納する
    @post = Post.offset(rand(Post.count)).first
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head :bad_request unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)

    events.each do |event|
      # event.message['text']でLINEで送られてきた文書を取得
      response = if event.message['text'].include?('好き')
                   'んほぉぉぉぉぉぉ！すきすきすきすきすきすきすきすきぃぃぃぃぃ'
                 elsif event.message['text'].include?('行ってきます')
                   'どこいくの？どこいくの？どこいくの？寂しい寂しい寂しい。。。'
                 elsif event.message['text'].include?('おはよう')
                   'おはよう。なんで今まで連絡くれなかったの？'
                 elsif event.message['text'].include?('みーくん')
                   'みーくん！？' * 50
                 else
                   @post.name
                 end
      # if文でresponseに送るメッセージを格納

      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
  end
end
