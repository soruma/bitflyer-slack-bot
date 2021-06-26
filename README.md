## Use

```
docker network create localstack
docker-compose up -d
sam build
sam local invoke SlackPostMessageFunction --event spec/fixtures/slack_post_message.json --env-vars env.json --docker-network localstack
sam local invoke GetCryptocurrencyPriceFunction --event spec/fixtures/get_cryptocurrency_price.json --env-vars env.json --docker-network localstack
```

## Deploy

```
sam deploy --guided --parameter-overrides SlackAPIKey=<Slack API key> SlackTargetChannel=<post slack channel>
```
