import axios from 'axios'
import camelCase from 'just-camel-case'
import snakeCase from 'just-snake-case'

function mapKeyRecursive(o: any, iteratee: (s: string) => string): any {
  if (Array.isArray(o)) {
    return o.map(item => mapKeyRecursive(item, iteratee))
  }
  if (typeof o === 'object') {
    return Object.keys(o).reduce((memo, key) => {
      const camelizedKey = iteratee(key)
      return { ...memo, [camelizedKey]: mapKeyRecursive(o[key], iteratee) }
    }, {})
  }
  return o
}

const camelizeKeyRecursive = (o: any): any => mapKeyRecursive(o, camelCase)

const snakeCaseKeyRecursive = (o: any): any => mapKeyRecursive(o, snakeCase)

const camelizeResponse = (res: any): any => ({ ...res, data: camelizeKeyRecursive(res.data) })

const snakeCaseOptions = (options: any): any => ({ ...options, params: snakeCaseKeyRecursive(options.params) })

export const get = (path: string, options: object) =>
  axios.get(path, snakeCaseOptions(options)).then(res => camelizeResponse(res))

export const post = (path: string, body: object, options: object) =>
  axios.post(path, snakeCaseKeyRecursive(body), snakeCaseOptions(options)).then(res => camelizeResponse(res))

export const put = (path: string, body: object, options: object) =>
  axios.put(path, snakeCaseKeyRecursive(body), snakeCaseOptions(options)).then(res => camelizeResponse(res))
