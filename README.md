# deployment_status Slack Notifier

Posts messages to slack based on github deployment_status webhook

## Configuration

### Environment Variables

This app uses the following environments variables:

| Name | Required | Description |
| ---| --- | ---|
| SECRET_TOKEN | Yes| If supplied it will do a HMAC check against the incomming request |
| SUCCESS_HOOKS | Yes | A csv of slack app webhooks to send success messages to  |
| FAILURE_HOOKS | Yes | A csv of slack app webhooks to send failure messages to |
| ERROR_HOOKS | Yes | A csv of slack app webhooks to send error messages to |

### Webhook

To configure the webhook you will want to do the following:

```bash
URL: <https://example.com/handler>
Events:
  Let me select:
    deployment_status (Only)
```

If you set a HMAC secret ensure that `SECRET_TOKEN` is set to the same secret value

## Docker images

Docker images are supplied under Xorima on docker hub, <https://hub.docker.com/r/xorima/deployment_status_slack_notifier/>
