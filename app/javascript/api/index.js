import { csrfToken } from './utils'

function postJSON(url, data) {
  return fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-CSRF-Token': csrfToken()
    },
    body: JSON.stringify(data)
  })
}

function getJSON(url) {
  return fetch(url, {
    headers: {
      'Accept': 'application/json'
    },
  }).then(resp => resp.json())
}

export default { getJSON, postJSON };
