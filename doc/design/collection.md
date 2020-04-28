# 概要

ここではcollectionの設計について記述する。

## 設計

まず、下記に各collectionのschemaを記載する。その後この設計意図について記述する。
なおQuestion/Answerに関しては[data collection](https://github.com/access-company/Dodai-doc/blob/master/datastore_api.md)を用いる。
collection名はそれぞれ下記である。
* Questionの保存するcollectionの名前 => `Question`
* Answerを保存するcollectionの名前 => `Answer`

Userに関しては[User collection](https://github.com/access-company/Dodai-doc/blob/master/users_api.md)を用いるが、`data`領域などは特に使わない。

### Schema 定義

* [Question](./question.yml)
* [Answer](./answer.yml)

### 例

#### Question Collection

```
{
  "_id": "5976b4b037000037006d69cc"
  "version": 0,
  "created_at": "2018-02-19T01:01:00+00:00",
  "updated_at": "2018-02-19T01:01:00+00:00",
  "sections": [],
  "owner": "_root",
  "data": {
    "title": "タイトル",
    "body": "本文",
    "userId": "5976b4b037000037006d69cc",
    "comments" [
      {
        "_id": "comment_id1",
        "body": "本文1",
        "userId": "5976b4b037000037006d69c0",
        "createdAt": "2018-02-19T01:01:00+00:00"
      },
      {
        "_id": "comment_id2",
        "body": "本文2",
        "userId": "5976b4b037000037006d69c1",
        "createdAt": "2018-02-19T01:02:00+00:00"
      }
    ]
    "likeVoterIds": [
      "5976b4b037000037006d69c2",
      "5976b4b037000037006d69c3"
    ],
    "dislikeVoterIds": [
      "5976b4b037000037006d69c4"
    ],
  },
}
```
### Answer collection

```
{
  "_id": "5976b4b037000037006d69c5"
  "version": 0,
  "createdAt": "2018-02-20T01:01:00+00:00",
  "updatedAt": "2018-02-20T01:01:00+00:00",
  "sections": [],
  "owner": "_root",
  "data": {
    "questionId": "5976b4b037000037006d69cc",
    "body": "本文",
    "userId": "5976b4b037000037006d69c5",
    "comments" [
      {
        "_id": "comment_id3",
        "body": "本文3",
        "userId": "5976b4b037000037006d69c6",
        "createdAt": "2018-02-20T01:02:00+00:00"
      },
      {
        "_id": "comment_id4",
        "body": "本文4",
        "userId": "5976b4b037000037006d69c7"
        "createdAt": "2018-02-20T01:03:00+00:00"
      }
    ]
  },
}
```

### 設計意図

下記に設計意図について記載する。

* Commentが関連するQuestion, Answerのdocumentに含まれている。
  * これは、Commentの取得は必ず、QuestionまたはAnswerとセットになるからである。
  * この観点ではAnswerもQuestionに含めることも考えられるが、ユーザ詳細ページでは、Userが行ったAnswerを取りたいというケースがあるのでQuestionとAnswerは分離している
* `likeVoterIds`, `disLikeVoterIds`が配列になっている。
  * 単純に現在の投票結果を数値で表さなかったのは、数値だけだと「すでに誰が投票済みか」という情報が消失してしまうため、同じUserにより重複した投票が可能になってしまうためである。
  * 実際の投票結果は`likeVoterIds`の要素の数 - `disLikeVoterIds`の要素の数で計算できる
