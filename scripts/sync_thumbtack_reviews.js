#!/usr/bin/env node
/* eslint-env node */
/**
 * Sync live Thumbtack reviews into _data/reviews.yml.
 * Run locally with: `node scripts/sync_thumbtack_reviews.js`
 * Requires network access and overwrites the reviews array with the latest
 * data scraped from the public Thumbtack service page.
 */

const fs = require('fs')
const https = require('https')
const path = require('path')
const { load } = require('cheerio')
const yaml = require('js-yaml')

const SERVICE_URL =
  'https://www.thumbtack.com/nj/absecon/tile/tillerstead-llc/service/547437618353160199'
const DATA_PATH = path.join(__dirname, '..', '_data', 'reviews.yml')
const BACKUP_PATH = path.join(__dirname, '..', '_data', 'reviews.backup.yml')

function fetchHtml (url) {
  return new Promise((resolve, reject) => {
    https
      .get(
        url,
        {
          headers: {
            'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124 Safari/537.36'
          }
        },
        res => {
          if (res.statusCode !== 200) {
            reject(new Error(`Request failed with status ${res.statusCode}`))
            return
          }

          let html = ''
          res.on('data', chunk => {
            html += chunk.toString()
          })
          res.on('end', () => resolve(html))
        }
      )
      .on('error', reject)
  })
}

function cleanHtml ($, element) {
  const clone = $(element).clone()
  clone.find('script, style, noscript').remove()
  const html = clone.html() || ''
  return html.trim()
}

function textFrom ($, element) {
  const value = $(element).text().trim()
  return value || null
}

function parseRating ($, card) {
  const ratingValue = card.find('[itemprop="ratingValue"]').attr('content')
  if (ratingValue) return { rating: parseFloat(ratingValue), ratingMax: 5 }

  const ariaLabel = card
    .find('[aria-label*="star"], [data-test*="rating"], .tt-rating')
    .first()
    .attr('aria-label')

  if (ariaLabel) {
    const match = ariaLabel.match(/([0-9.]+)\s*(?:out of\s*([0-9.]+))?/i)
    if (match) {
      const rating = parseFloat(match[1])
      const ratingMax = match[2] ? parseFloat(match[2]) : 5
      if (!Number.isNaN(rating)) return { rating, ratingMax }
    }
  }

  const starCount = card.find('[data-test="star"], .tt-star').length
  if (starCount) return { rating: starCount, ratingMax: 5 }

  return { rating: null, ratingMax: 5 }
}

function slugify (value) {
  return (value || '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function parseDate ($, card) {
  const time = card.find('time').first()
  const datetime = time.attr('datetime')
  if (datetime) return datetime.trim()

  const text = textFrom($, time)
  if (text) {
    const parsed = new Date(text)
    if (!isNaN(parsed)) return parsed.toISOString().split('T')[0]
  }
  return null
}

function extractReviews (html) {
  const $ = load(html)

  const reviewCards = $(
    [
      '[data-test="review-card"]',
      '[data-testid="review-card"]',
      'article:has([data-test="review-card-header"])',
      '.review-card',
      'section:has([itemprop="reviewBody"])'
    ].join(', ')
  )

  if (!reviewCards.length) {
    throw new Error('No review cards found. Thumbtack may have changed their markup.')
  }

  return reviewCards
    .map((index, el) => {
      const card = $(el)

      const body =
        card.find('[data-test="review-card-body"], [data-testid="review-body"], [itemprop="reviewBody"], .review-body').first()
      const author =
        textFrom(
          $,
          card.find(
            '[data-test*="consumer-name"], [itemprop="author"], [data-testid*="reviewer"], .reviewer, .reviewer-name'
          ).first()
        ) || 'Client'
      const location =
        textFrom($, card.find('[data-test*="location"], .consumer-location, .reviewer-location').first()) || null
      const jobType =
        textFrom($, card.find('[data-test*="project"], [data-test*="job"], .project-type, .job-type').first()) || null
      const date = parseDate($, card)
      const badgeEls = card.find('[data-test*="badge"], .badge, .pill, .chip')
      const badges = badgeEls
        .map((_, badgeEl) => textFrom($, badgeEl))
        .get()
        .filter(Boolean)

      const { rating, ratingMax } = parseRating($, card)

      const quoteHtml = body.length ? cleanHtml($, body) : ''
      const baseSlug = slugify(author)
      const id = `thumbtack-${baseSlug || 'client'}-${index + 1}`

      return {
        id,
        source: 'Thumbtack',
        platform: 'Thumbtack',
        rating: rating || null,
        rating_max: ratingMax || 5,
        quote_html: quoteHtml,
        author,
        location,
        job_type: jobType,
        date,
        badges,
        url: SERVICE_URL
      }
    })
    .get()
}

function backupExisting () {
  if (fs.existsSync(DATA_PATH)) {
    fs.copyFileSync(DATA_PATH, BACKUP_PATH)
    console.log(`Backed up existing data to ${BACKUP_PATH}`)
  }
}

function writeYaml (reviews) {
  const yamlBody = yaml.dump({ reviews }, { lineWidth: 1000 })
  fs.writeFileSync(DATA_PATH, yamlBody)
  console.log(`Wrote ${reviews.length} review(s) to ${DATA_PATH}`)
}

async function main () {
  try {
    console.log(`Fetching Thumbtack reviews from ${SERVICE_URL}`)
    const html = await fetchHtml(SERVICE_URL)
    const reviews = extractReviews(html)

    if (!reviews.length) {
      throw new Error('Parsed review list is empty; aborting write to prevent data loss.')
    }

    backupExisting()
    writeYaml(reviews)
  } catch (error) {
    console.error('Failed to sync Thumbtack reviews:', error.message)
    process.exitCode = 1
  }
}

main()
