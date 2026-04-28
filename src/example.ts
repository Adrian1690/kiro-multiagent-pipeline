// Demo file — intentionally has issues for the agents to find.
// The review pipeline will flag: missing tests, any type, no error handling.

export function getUser(id: any) {
  const query = `SELECT * FROM users WHERE id = ${id}` // SQL injection risk
  return fetch(`/api/users/${id}`).then(r => r.json())
}

export const MAX_RETRIES = 3
