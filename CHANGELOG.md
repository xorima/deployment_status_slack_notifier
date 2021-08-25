# CHANGELOG

This file is used to list changes made in Deployment_status Slack Notifier.

## 1.2.2 - *2021-08-25*

- Fixed bug with `SKIP_LABEL` where it did not count the labels matching correctly

## 1.2.1 - *2021-08-24*

- Fixed bug with `SKIP_LABEL` where it stopped sending any notifications

## 1.2.0 - *2021-08-14*

- add a `SKIP_LABEL` env var to skip success notifications on a specific label

## 1.1.1 - *2020-11-18*

- Fixed bug with dockerhub push due to set-env deprecation

## 1.1.0 - *2020-11-17*

- Fixed bug in dockerfile name
- Include correct gems
- Added readme documentation

## 1.0.0 - *2020-11-17*

- Sends deployment_status to slack
