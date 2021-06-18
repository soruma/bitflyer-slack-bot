```
sam build
sam local invoke SlackPostMessageFunction --event spec/fixtures/slack_post_message.json --env-vars env.json
sam local invoke BitflyerTickerFunction --event spec/fixtures/bitflyer_ticker.json --env-vars env.json
```
