import ja from '@/assets/strings/ja'

const locales = { ja }
type LocaleKey = keyof typeof locales

const language = (window.navigator.languages.find((lang: string) => lang in locales) || 'ja') as LocaleKey

export default locales[language]
