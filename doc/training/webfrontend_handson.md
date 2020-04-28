# Webfrontend開発ハンズオン

## 内容

* 今後作成するものを理解する。
* ツールの概要・使い方を理解する。
* `質問詳細ページ(1.質問の表示)`を実装する。
  * 質問詳細ページを全て実装するのではなく、質問の表示(コメントを含まない。タイトルと本文の表示)のみを対応する。

## 利用しているツールの説明

### 開発環境用のツール・ライブラリ

* [Yarn](https://yarnpkg.com/en/)
  * パッケージマネージャー。
* [Node.js](https://nodejs.org/en/)
  * ブラウザを使わないJavaScriptの実行環境。このプロジェクトではYarnの実行やユニットテストの実行環境に利用する。
* [Webpack](https://webpack.js.org/)
  * ビルドツール。
* [ESLint](https://eslint.org/)
  * JavaScript/TypeScript用のLint。オプション(--fix)でコードの修正もしてくれる。
  * 設定ファイルは[.eslintrc.yaml](../../.eslintrc.yaml)

### 実環境でも利用されるライブラリ

* [React](https://github.com/facebook/react)
* [Font Awesome](https://fontawesome.com/)
  * アイコン。
  * このプロジェクトではフリーのアイコンを利用する。
* [Axios](https://github.com/axios/axios)
  * PromiseベースのHTTPライブラリ。
* [clsx](https://github.com/axios/axios)
  * 要素に複数のクラス名を設定しやすくするためのライブラリ。

## フロントエンド関係のファイルの場所

TODO: 実装済みかどうかを記載。

<pre>
|-- web/
|   |-- static/   静的なファイルの置き場所
|       |-- assets/  CSSファイル
|           |-- css/      共通で利用するCSSファイル
|           |-- strings/  文言ファイル
|       |-- app/     TypeScriptのコード置き場
|           |-- common/  共通で利用する処理の置き場
|               |-- http_client.ts  HTTPクライアントのラッパー。今回WebAPIのフィールド名はスネースケースだが、TypeScriptではキャメルケースにしたいこで変換する。
|               |-- api.ts          サーバのWebAPIの呼び出し処理。
|               |-- constants.ts    定数
|               |-- paths.ts        各ページのパスの定義。
|               |-- validator.ts    値のバリデーションの定義。
|           |-- pages/  各ページのコンポーネント
|               |-- Login/             "ログインページ"。
|               |-- QuestionCreation/  "質問投稿ページ"。
|               |-- QuestionList/      "質問一覧ページ"。
|               |-- QuestionDetail/    "質問詳細ページ"。
|               |-- UserDetail/        "ユーザ詳細ページ"。
|           |-- components/  ページより小さいレベルのコンポーネント。複数のページから利用する可能性がある。
|               |-- AnswerItem/      "回答コンポーネント"。"質問詳細ページ"で利用される。
|               |-- AnswerOverview/  "回答概要コンポーネント"。"ユーザ詳細ページ"の回答の一覧で利用される。
|               |-- AnswerPost/      "回答投稿コンポーネント"。"質問詳細ページ"で利用される。
|               |-- CommentItem/     "コメントコンポーネント"。"質問詳細ページ"で利用される。
|               |-- CommentPost/     "コメント投稿コンポーネント"。"質問詳細ページ"で利用される。
|               |-- Footer/          "フッターコンポーネント"。各ページのフッター。
|               |-- Header/          "ヘッダーコンポーネント"。各ページのヘッダー。
|               |-- LoginForm/       "ログインフォームコンポーネント"。ログインページのログインフォーム。
|               |-- QuestionDetail/  "質問詳細コンポーネント"。質問詳細ページで利用される。
|                   |-- AnswerList/    "回答一覧コンポーネント"。
|                   |-- Question/      "質問ログインページ"。
|               |-- QuestionPost/    "Userログインページ"。質問投稿ページで利用される。
|               |-- VoteItem/        "Userログインページ"。Like/Dislikeに利用される。
|           |-- models/  回答・コメント・質問・Like/Dislikeのデータ構造のインターフェイス定義
|       |-- main.tsx          TypeScriptのスタートポイント。これがhtmlから呼ばれる。
|-- .eslintrc.yaml     ESLintの設定ファイル
|-- .prettierrc.yaml   Prettierの設定ファイル
|-- .prettierignore    Prettierの対象としないファイルの設定ファイル
|-- package.json       Yarnのパッケージ情報ファイル
|-- webpack.config.js  WebPackのローカル/デプロイの共通設定のファイル
|-- webpack.dev.js     WebPackのローカルでの開発用の設定ファイル
|-- webpack.prod.js    WebPackのデプロイ用の設定ファイル
|-- yarn.lock          Yarnの設定ファイル
</pre>

## Webfrontend向けのセットアップを行う

* [Webfrontend向けのセットアップ](../development.md)に従い、セットアップを行う。

## Webfrontendの実行

* [Webfrontendのwebpack-dev-serverの実行](../development.md#webfrontendのwebpack-dev-serverの実行)を行う。
  * この状態でJavaScriptのコードを修正するとブラウザが自動的にブラウザでリロードされる。

## Reactのコードの例として`質問一覧ページ`のコードを見る

[QuestionListPage/index.tsx](../../web/static/app/pages/QuestionListPage/index.tsx)のコメントを使って説明する。

## `Chrome Devtools`でリクエストを確認する

* `質問一覧ページ`をブラウザで開いている時に、`Chrome Devtools`の`Network`タブを開いた状態で、ページのリロードを行う。
  * question APIに対してGETのリクエストをしていることが確認できる。

## React Developer Toolsの使い方を知る

* `質問一覧ページ`をブラウザで開いている時に、`Chrome Devtools`を開き`Components`タブを選択する。
  * Reactのコンポーネントのツリーが表示される。
  * Reactのコンポーネントを選択すると中のデータ(props, hook)が表示される。

## ESLint/Prettierの挙動を確認する

* 1. [QuestionListPage/index.tsx](../../web/static/app/pages/QuestionListPage/index.tsx)のコードフォーマットを修正する。
```ts
  useEffect(() => {
-    retrieveQuestions().then(items => {
+    retrieveQuestions(   ).  then(  items => { // よくわからない空白を追加する
      // GearのAPIから質問一覧を取得する。非同期で取得をするためにPromise()を利用する。
      setQuestions(items) // 取得した質問をこのコンポーネントのstateに保存する。stateを変更することで、コンポーネントの関数が再度実行される。
    })
  }, [])
```

* 2. `$ yarn lint`を実行するとエラーが表示されずに自動的にフォーマットが修正されていることを確認する。

## `質問一覧ページ`への機能追加を行う

### 1. 一覧に質問の作成日時を表示する。

質問一覧ページには質問のタイトルと投稿者のIDが表示されているが、質問の作成日時を表示するように修正する。

- 質問一覧ページの各質問の表示は[QuestionItem/index.tsx](../../web/static/app/components/QuestionItem/index.tsx)で行われている。
- `question`が渡されているので、その中にある生成日時を出力すればいい。

この時点でのコードは下記になる。

```ts
import React, { FC } from 'react'
import { Link } from 'react-router-dom'
import style from '@/app/components/QuestionItem/style.scss'
import { Question } from '@/app/models/Question'
import words from '@/assets/strings'
import { paths } from '@/app/common/paths'

interface Props {
  readonly question: Question
  readonly isUserIdShow?: boolean
}

export const QuestionItem: FC<Props> = ({ question, isUserIdShow }: Props) => (
  <div>
    <h5 className={style.title}>
      <Link to={paths.question(question.id)}>{question.title}</Link>
    </h5>

    <div className={style.additional}>
      {question.createdAt} {/* 作成日時を追加 */}
      {' '}
      {isUserIdShow && (
        <>
          {words.common.by}
          <Link to={paths.user(question.userId)}>{question.userId}</Link>
        </>
      )}
      <hr className={style.hr} />
    </div>
  </div>
)
```

### 2. 一覧で質問を作成日時の降順でソートして表示する。

質問一覧ページには質問がサーバから受け取った一覧の順番で表示されているが、作成日時が新しいものを先に表示するように修正する。

- [QuestionListPage/index.tsx](../../web/static/app/pages/QuestionListPage/index.tsx)で`questions`の先頭`QUESTION_LIMIT`を利用している。
- `questions`を作成日時で降順にソートしてから`QuestionItem`で表示すればいい。JavaScriptの文字列比較は[String.prototype.localeCompare()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/localeCompare)でできる。今回は英数字なので`<`や`>`での比較でもいい。

この時点でのコードは下記になる。

```ts
import React, { FC, useState, useEffect } from 'react'
import { Link, useHistory } from 'react-router-dom'
import { Header } from '@/app/components/Header'
import { Footer } from '@/app/components/Footer'
import { Question } from '@/app/models/Question'
import words from '@/assets/strings'
import style from '@/app/pages/QuestionListPage/style.scss'
import { QuestionItem } from '@/app/components/QuestionItem'
import { paths } from '@/app/common/paths'
import { QUESTION_LIMIT } from '@/app/common/constants'
import { retrieveQuestions, logout } from '@/app/common/api'
import { getCurrentUserId } from '@/app/common/utils'

const QuestionListPage: FC = () => {
  const [questions, setQuestions] = useState<Question[]>([]) // このコンポーネントはstateとして質問一覧のデータを保持する。
  const history = useHistory()
  const currentUserId = getCurrentUserId()

  // useEffect()でページが表示される時に実行される処理を設定する。
  // https://reactjs.org/docs/hooks-reference.html#useeffect
  useEffect(() => {
    retrieveQuestions().then(items => {
      // GearのAPIから質問一覧を取得する。非同期で取得をするためにPromise()を利用する。
      setQuestions(items) // 取得した質問をこのコンポーネントのstateに保存する。stateを変更することで、コンポーネントの関数が再度実行される。
    })
  }, [])

  const handleLogin = () => {
    history.push(paths.login)
  }

  const sortedQuestions = questions.sort((a, b) => b.createdAt.localeCompare(a.createdAt))

  return (
    <>
      <Header userId={currentUserId} handleLogin={handleLogin} handleLogout={logout} />
      <div className={style.main}>
        <div className={style.pageTitle}>{words.top.title}</div>

        <Link to={`${paths.questionCreate}`}>{words.top.question}</Link>
        <hr className={style.hr} />

        {/* 先頭からQUESTION_LIMITの件数だけ取り出して、それぞれQuestionItemに渡して表示をする */}
        {sortedQuestions.slice(0, QUESTION_LIMIT).map((question: Question) => (
          <QuestionItem key={`QuestionList_QuestionItem_${question.id}`} question={question} isUserIdShow />
        ))}
      </div>
      <Footer />
    </>
  )
}

export default QuestionListPage
```
