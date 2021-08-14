# CHANGELOG

This file is used to list changes made in Deployment_status Slack Notifier.

## Unreleased

- add a `SKIP_LABEL` env var to skip success notifications on a specific label

## 1.1.1 - *2020-11-18*

- Fixed bug with dockerhub push due to set-env deprecation

## 1.1.0 - *2020-11-17*

- Fixed bug in dockerfile name
- Include correct gems
- Added readme documentation

## 1.0.0 - *2020-11-17*

- Sends deployment_status to slack
