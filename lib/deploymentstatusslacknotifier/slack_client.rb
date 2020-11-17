# frozen_string_literal: true

require 'httparty'
require 'hashie'
require 'json'

module DeploymentStatusSlackNotifier
  # Handles messaging to Slack using webhooks
  class SlackClient
    include HTTParty

    def initialize(success_hooks, failure_hooks, error_hooks)
      @success_hooks = success_hooks
      @failure_hooks = failure_hooks
      @error_hooks = error_hooks
    end

    def success_message(message)
      @success_hooks.each do |hook|
        send_message(hook, message)
      end
    end

    def failure_message(message)
      @failure_hooks.each do |hook|
        send_message(hook, message)
      end
    end

    def error_message(message)
      @error_hooks.each do |hook|
        send_message(hook, message)
      end
    end

    private

    def post(url, params = {}, headers: { 'Content-type' => 'application/json' })
      self.class.post url, body: params, headers: headers
    end

    def send_message(hook, message)
      params = { 'text' => message }.to_json
      post(hook, params)
    end
  end
end
