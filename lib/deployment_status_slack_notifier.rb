# frozen_string_literal: true

require_relative 'deploymentstatusslacknotifier/slack_client'
require_relative 'deploymentstatusslacknotifier/hmac'

require 'sinatra'
require 'json'

get '/' do
  'Alive'
end

post '/handler' do
  return halt 500, "Signatures didn't match!" unless validate_request(request)

  payload = JSON.parse(params[:payload])
  case request.env['HTTP_X_GITHUB_EVENT']
  when 'deployment_status'
    unless %w[success failure error].include? payload['deployment_status']['state']
      return "Unhandled deployment_status: #{payload['deployment_status']['state']}"
    end

    success_webhooks = ENV['SUCCESS_WEBHOOKS'].split(',')
    failure_webhooks = ENV['FAILURE_WEBHOOKS'].split(',')
    error_webhooks = ENV['ERROR_WEBHOOKS'].split(',')
    skip_label_name = ENV['SKIP_LABEL'] if ENV['SKIP_LABEL']

    skip_success_notification = skip_label?(payload, skip_label_name) if skip_label_name

    slack = DeploymentStatusSlackNotifier::SlackClient.new(success_webhooks, failure_webhooks, error_webhooks)
    case payload['deployment_status']['state']
    when 'success'
      msg = success_message_body(payload)
      slack.success_message(msg) unless skip_success_notification
    when 'failure'
      msg = success_message_body(payload)
      slack.failure_message(msg)
    when 'error'
      msg = success_message_body(payload)
      slack.error_message(msg)
    end
  end
end

def validate_request(request)
  true unless ENV['SECRET_TOKEN']
  puts(ENV['SECRET_TOKEN'])
  request.body.rewind
  payload_body = request.body.read
  verify_signature(payload_body)
end

def success_message_body(payload)
  deployment_payload = JSON.parse(payload['deployment']['payload'])
  body = deployment_payload['release_body'].gsub("\n-", "\n•").gsub(/^-/, '•')
  puts(body)
  repo_name = payload['repository']['name']
  version = payload['deployment']['ref']
  pull_request_link = deployment_payload['pull_request']['html_url']
  "#{repo_name} version #{version} has been released:\n#{body}\n\n<#{pull_request_link}|Pull Request Link>"
end

def failure_message_body(payload)
  repo_name = payload['repository']['name']
  version = payload['deployment']['ref']
  error = payload['deployment_status']['description']
  "Failure on Release: #{repo_name} version #{version} \nError: #{error}"
end

def error_message_body(payload)
  repo_name = payload['repository']['name']
  version = payload['deployment']['ref']
  "UNKNOWN ERROR on Release: #{repo_name} version #{version}"
end

def skip_label?(payload, label)
  return false unless label

  payload = JSON.parse(payload['deployment']['payload'])

  label_count = payload['pull_request']['labels'].select { |l| l['name'] =~ /^#{label}/i }
  return true if label_count == 1

  false
end
