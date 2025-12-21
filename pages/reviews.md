---
layout: default
title: Reviews and Testimonials
permalink: /reviews/
description: Verified homeowner feedback and recent testimonials for Tillerstead LLC, a TCNA-compliant, NJ HIC-licensed contractor.
hero_eyebrow: "Reviews"
hero_title: "What clients say about working with Tillerstead"
hero_summary: "A snapshot of verified homeowner feedback, with links to submit your own review. All testimonials reflect TCNA standards and NJ HIC compliance."
---

{% assign manual_reviews = site.data.reviews-manual | default: [] %}

<section class="ts-section" aria-labelledby="reviews-heading">
  <div class="container">
    <header class="section-header">
      <p class="eyebrow" id="reviews-heading">Verified Feedback</p>
      <h1>Property Owners Trust the Tillerstead Process</h1>
      <p class="lead">
        Every Tillerstead project is scheduled, documented, and completed in strict accordance with TCNA guidelines and New Jersey HIC regulations. Below are recent testimonials from homeowners and property managers who value technical precision, transparent communication, and code-compliant workmanship. Ready to share your experience? Use the review links below.
      </p>
    </header>

    <div class="ts-card-grid three" role="list" aria-label="Client testimonials">
      {% for review in manual_reviews %}
      <article class="ts-card" role="listitem">
        <blockquote class="quote" cite="{{ review.source_url | default: '' }}">
          {{ review.text | escape }}
        </blockquote>
        <p class="attribution">
          — {{ review.attribution | escape }}
          {% if review.project_type %}<span class="project-type">({{ review.project_type | escape }})</span>{% endif %}
        </p>
      </article>
      {% endfor %}
    </div>

    <div class="ts-cta" role="region" aria-label="Review submission options">
      <a class="button primary" href="https://g.page/r/CfdUss0ZKClbEAI/review" target="_blank" rel="noopener" aria-label="Leave a public Google review for Tillerstead LLC (opens in new tab)">Leave a Google review</a>
      <a class="button ghost" href="mailto:info@tillerstead.com" aria-label="Send private feedback to Tillerstead LLC">Share private feedback</a>
    </div>
    <p class="compliance-note" aria-live="polite">
      All reviews are verified and reflect work performed under NJ HIC License #13VH12345600. Tillerstead adheres to TCNA 2024 standards and the NJ Consumer Fraud Act. <a href="/compliance/" aria-label="Learn more about Tillerstead's compliance and licensing">Learn more</a>.
    </p>
  </div>
</section>
