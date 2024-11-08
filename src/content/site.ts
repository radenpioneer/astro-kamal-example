import { glob } from 'astro/loaders'
import { defineCollection, z } from 'astro:content'

export default defineCollection({
  type: 'content_layer',
  loader: glob({ base: 'src/data/site', pattern: '**/*.json' }),
  schema: z.object({
    title: z.string().max(64),
    description: z.string().max(256)
  })
})
