export default {
  common: {
    additional: (additional: string) => `Posted at ${additional}  `,
    by: 'by ',
    hyphen: '-- ',
    save: '保存',
    update: '更新',
    cancel: 'キャンセル',
    textErrorEmpty: '入力してください。',
  },
  header: {
    title: 'StackOverflow Clone',
    login: 'ログイン',
    logout: 'ログアウト',
  },
  top: {
    title: '質問一覧',
    question: '質問する',
  },
  sidebar:{
    home: 'ホーム',
    unsolved:'未解決',
  },
  bookList: {
    title: '本一覧',
    create: '本を登録する',
  },
  user: {
    title: 'ユーザー詳細',
    questionList: '質問一覧',
    answerList: '回答一覧',
  },
  login: {
    title: 'ログイン',
    login: 'ログイン',
    id: 'ユーザ ID:',
    idPlaceholder: 'ID',
    idErrorEmpty: '入力必須項目です',
    idErrorInvalid: '無効なメールアドレスです',
    password: 'パスワード',
    passwordPlaceholder: 'パスワード',
    passwordErrorEmpty: '入力必須項目です',
    passwordErrorInvalid: '無効なパスワードです',
    loginError: 'ログインに失敗しました',
  },
  questionCreate: {
    title: 'タイトル',
    body: '本文',
    tag: 'タグ',
    create: '投稿する',
    postQuestion: '質問を投稿する',
    notLoginBody: '質問を投稿するにはログインしてください。',
  },
  bookCreate: {
    title: 'タイトル',
    author: '著者',
    create: '登録する',
    postBook: '本を登録する',
  },
  book: {
    post: '登録',
  },
  question: {
    answer: '回答する',
    answerNumber: (number: number) => `${number}件の回答`,
    loginToComment: 'コメントするにはログインしてください。',
    loginToAnswer: '回答するにはログインしてください。',
    commentAdd: 'コメントを追加',
    post: '投稿',
    time: '質問日時',
  },
  tag: {
    description: 'のタグがついた質問一覧'
  }
} as const
