# Server, Webfrontend開発実習

## 目的

* Server側
  * 簡単なgearのコードを理解、記述することができ、実際に業務としてgearの開発する下地を身につける。
  * gearの開発を通して、Serverの役割やClientを含めた処理の流れを理解する。

* Webfrontend側
  * 仮想DOMを利用したフレームワークであるReact、各種開発ツールを使ったSPA(Single Page Application)の開発を通し現代的なWebfrontend開発の概要を知ることで、今後Webfrontendの開発に関わる時に必要となる知識の下地を身につける。

## 実習概要

本自習では[Stackoverflow](https://stackoverflow.com/)のクローンアプリの開発を行なう。
実習はServer実習とWebfrontendの実習の2部構成となる。

最初に質問一覧画面の一部が実装済みのコードを提供いたします。
本実習ではこのコードを元に未実装部分を実装するという流れで行います。

## 作成物詳細

[仕様](../spec/spec.md)を満たす、Stackoverflowのクローンアプリを開発する。
成果物のデモは[こちら](https://stackoverflow-clone.solomondev.access-company.com)

### Server側開発項目

Serverの実習としては上記の仕様を満たすUIを実現するためのGearのWeb APIの開発を行なう。
Web APIの仕様は[ここ](../spec/api_spec.yml)を参照。
User関連のAPIは実装済みであるため、それ以外のAPIの実装を行なう。
ただし、各APIについてはテストコードをも書く。

API仕様書は[Swagger](https://swagger.io/)で記載しており、[オンラインエディタ](https://editor.swagger.io/)で閲覧するのがおすすめです。
(左側の編集画面の中身を[api_spec.yml](../spec/api_spec.yml)で上書きしましょう。)
また、上記のページで各APIの"Try it out"ボタン => "Execute"ボタンをクリックすることでAPIを叩くための`curl`のコマンドが生成されるので動作確認に便利です。(URLの部分だけは各自のものに変更が必要)

### Webfrontend側開発項目

Webfrontendの実習としては開発されたGearのWeb APIを利用して各画面のUIを作成しStackoverflowクローンを完成させる。

## 開発スケジュール

初日はAPI実装 => UIの実装の流れを掴んでいただくためハンズオン形式で行う。
以降はGearの開発として4.5日、後にWebfrontendの開発として4.5日を期間をとり最終日の半日をつかって成果物の発表を行う。

詳細なスケジュールは下記としているが、時間に余裕がある方は翌日の作業を始めても良い。

### 初日のハンズオン

* ハンズオン形式で質問詳細画面の開発を行う。
  * [Server側は質問取得API(`GET /v1/question/:id`)の開発](./server_handson.md)
  * [Client側は質問一覧画面の修正](./webfrontend_handson.md)

### [Server実習1日目](./server_1day.md)

### [Server実習2日目](./server_2day.md)

### [Server実習3日目](./server_3day.md)

### [Server実習4日目](./server_4day.md)

### [Server実習5日目](./server_5day.md)

### [Webfrontend実習1日目](./webfrontend_1day.md)

### [Webfrontend実習2日目](./webfrontend_2day.md)

### [Webfrontend実習3日目](./webfrontend_3day.md)

### [Webfrontend実習4日目](./webfrontend_4day.md)

## 開発ルール

master branchへのcommitは必ずPull Requestによるレビューをした後に行ってください。
master branchへのcommitまでの流れは下記です。

1. topic branchを作成して開発を行なう。
1. master branchへのPull Reuqest(PR)を行なう。
   * PRを行う前にセルフレビューや各言語やフレームワークに応じた確認を行なう。
   * Gearの開発では[ここ](../development.md#gearのテストの実行)で記載したテスト、dialyzer, credoを実施する。
   * Webfrontendの開発では[ここ](../development.md#WebfrontendのLint)で記載したlintを実施する。
1. チームメンバーはPRをレビューする。
1. レビュー内容を修正し、チームメンバーは修正内容に問題がないか確認する。
1. 全てのメンバーのレビューとその修正が完了したらmaster branchにmergeし、PRのcloseとbranchの削除を行なう。

## その他

* 実習中不明点などがあれば積極的に講師にご質問ください。
* **この実習での全ての資料の説明(コードの中身も含みます)としてStackoverflowCloneと書かれている部分はStackoverflowCloneAのような各自のpair名に応じたものに置き換えてください**
* サンプルとして`Book`リソースにたいするCRU(D) APIの実装がありますので、必要に応じて参照ください。
  * [仕様](../spec/book_api_spec.yml)
  * [Gear側の実装](../../web/controller/book/)
  * [Gear側のテスト](../../test/web/controller/book/)
* [Gear側のQ&A](./server_qaa.md)も必要に応じで参照ください。
* [Webfrontend側のQ&A](./webfrontend_qaa.md)も必要に応じで参照ください。
