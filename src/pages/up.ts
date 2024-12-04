import type { APIRoute } from 'astro'

export const GET: APIRoute = () => {
  return new Response('OK', {
    headers: {
      'Content-Type': 'text/plain'
    }
  })
}
