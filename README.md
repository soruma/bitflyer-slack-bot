## Use

```
sam build
sam local invoke SlackPostMessageFunction --event spec/fixtures/slack_post_message.json --env-vars env.json
sam local invoke BitflyerTickersFunction --event spec/fixtures/bitflyer_tickers.json --env-vars env.json
```

## Deploy

```
sam deploy --guided --parameter-overrides SlackAPIKey=<Slack API key> SlackTargetChannel=<post slack channel>
```
