### reference
```
https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/DynamoDBLocal.DownloadingAndRunning.html
```

### 기동방법
```
colima start --cpu 2 --memory 1 --disk 10
docker compose down -v
docker compose up -d
docker compose logs -f dynamodb-init
```

### 접속방법
```
export AWS_ACCESS_KEY_ID=dummy
export AWS_SECRET_ACCESS_KEY=dummy
export AWS_DEFAULT_REGION=us-west-2

aws dynamodb list-tables --endpoint-url http://localhost:8000
```



---
## 사용 방법
### 0️⃣ 전제 조건 (한 번만 확인)

* DynamoDB Local 실행 중
* 더미 자격 증명 설정됨 (`aws configure` 또는 환경변수)

모든 커맨드에는 **반드시 이 옵션이 붙음**:

```bash
--endpoint-url http://localhost:8000
```

공식 근거:

* [https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html)

---

### 1️⃣ 테이블 목록 조회

```bash
aws dynamodb list-tables \
  --endpoint-url http://localhost:8000
```

결과:

```json
{
  "TableNames": []
}
```

---

### 2️⃣ 테이블 생성 (가장 기본 예제)

#### PK 하나만 있는 테이블

* Partition Key: `id` (String)

```bash
aws dynamodb create-table \
  --table-name Users \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --endpoint-url http://localhost:8000
```

확인:

```bash
aws dynamodb describe-table \
  --table-name Users \
  --endpoint-url http://localhost:8000
```

공식 문서:

* [https://docs.aws.amazon.com/cli/latest/reference/dynamodb/create-table.html](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/create-table.html)

---

### 3️⃣ 아이템 추가 (PutItem)

```bash
aws dynamodb put-item \
  --table-name Users \
  --item '{
    "id": {"S": "user-1"},
    "name": {"S": "Juni"},
    "age": {"N": "30"}
  }' \
  --endpoint-url http://localhost:8000
```

핵심 규칙:

* 문자열 → `"S"`
* 숫자 → `"N"`
* Boolean → `"BOOL"`

공식 문서:

* [https://docs.aws.amazon.com/cli/latest/reference/dynamodb/put-item.html](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/put-item.html)

---

### 4️⃣ 단건 조회 (GetItem)

```bash
aws dynamodb get-item \
  --table-name Users \
  --key '{
    "id": {"S": "user-1"}
  }' \
  --endpoint-url http://localhost:8000
```

---

### 5️⃣ 전체 조회 (Scan) ⚠️ 개발용만

```bash
aws dynamodb scan \
  --table-name Users \
  --endpoint-url http://localhost:8000
```

⚠️ 실서비스에서는 Scan은 거의 금기
(로컬/테스트에서만 OK)

공식 문서:

* [https://docs.aws.amazon.com/cli/latest/reference/dynamodb/scan.html](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/scan.html)

---

### 6️⃣ 조건 조회 (Query)

👉 **Partition Key 기반 조회**

```bash
aws dynamodb query \
  --table-name Users \
  --key-condition-expression "id = :id" \
  --expression-attribute-values '{
    ":id": {"S": "user-1"}
  }' \
  --endpoint-url http://localhost:8000
```

공식 문서:

* [https://docs.aws.amazon.com/cli/latest/reference/dynamodb/query.html](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/query.html)

---

### 7️⃣ 아이템 수정 (UpdateItem)

```bash
aws dynamodb update-item \
  --table-name Users \
  --key '{
    "id": {"S": "user-1"}
  }' \
  --update-expression "SET age = :age" \
  --expression-attribute-values '{
    ":age": {"N": "31"}
  }' \
  --endpoint-url http://localhost:8000
```

---

### 8️⃣ 아이템 삭제 (DeleteItem)

```bash
aws dynamodb delete-item \
  --table-name Users \
  --key '{
    "id": {"S": "user-1"}
  }' \
  --endpoint-url http://localhost:8000
```

---

### 9️⃣ 테이블 삭제

```bash
aws dynamodb delete-table \
  --table-name Users \
  --endpoint-url http://localhost:8000
```

---

### 🔟 자주 쓰는 보조 커맨드

#### 테이블 상태 확인

```bash
aws dynamodb describe-table \
  --table-name Users \
  --endpoint-url http://localhost:8000
```

#### 테이블이 ACTIVE 될 때까지 대기

```bash
aws dynamodb wait table-exists \
  --table-name Users \
  --endpoint-url http://localhost:8000
```

공식 문서:

* [https://docs.aws.amazon.com/cli/latest/reference/dynamodb/wait/table-exists.html](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/wait/table-exists.html)

---

### 실무에서 중요한 포인트 요약

| 항목           | 설명                                 |
| ------------ | ---------------------------------- |
| endpoint-url | 로컬이면 항상 필요                         |
| 인증           | DynamoDB Local은 검증 안 함, CLI는 더미 필요 |
| Scan         | 테스트만 사용                            |
| Query        | 실무 기본                              |
| billing-mode | 로컬에선 `PAY_PER_REQUEST`가 편함         |

---

### 공식 문서 링크 모음 (근거)

* DynamoDB Local Usage Notes
  [https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/DynamoDBLocal.UsageNotes.html)
* AWS CLI DynamoDB Reference
  [https://docs.aws.amazon.com/cli/latest/reference/dynamodb/index.html](https://docs.aws.amazon.com/cli/latest/reference/dynamodb/index.html)
* DynamoDB 기본 개념
  [https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/Introduction.html](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/Introduction.html)

---

