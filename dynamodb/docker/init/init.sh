#!/usr/bin/env sh
set -e

ENDPOINT="http://dynamodb-local:8000"
REGION="${AWS_DEFAULT_REGION:-us-west-2}"
TABLE="Users"

echo "Waiting for DynamoDB Local..."
until aws dynamodb list-tables \
  --endpoint-url "$ENDPOINT" \
  --region "$REGION" >/dev/null 2>&1; do
  sleep 1
done

echo "Creating table if not exists..."
if aws dynamodb describe-table \
  --table-name "$TABLE" \
  --endpoint-url "$ENDPOINT" \
  --region "$REGION" >/dev/null 2>&1; then
  echo "Table $TABLE already exists. Skipping create."
else
  aws dynamodb create-table \
    --table-name "$TABLE" \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --endpoint-url "$ENDPOINT" \
    --region "$REGION"

  aws dynamodb wait table-exists \
    --table-name "$TABLE" \
    --endpoint-url "$ENDPOINT" \
    --region "$REGION"
fi

echo "Seeding 100 items..."

i=1
while [ $i -le 100 ]; do
  aws dynamodb put-item \
    --table-name "$TABLE" \
    --item "{
      \"id\": {\"S\": \"user-$i\"},
      \"name\": {\"S\": \"User $i\"},
      \"age\": {\"N\": \"$(($i % 50 + 20))\"}
    }" \
    --endpoint-url "$ENDPOINT" \
    --region "$REGION"

  i=$(($i + 1))
done

echo "Seed done (100 items)."
