# Email Drip Campaign Templates for Tillerstead LLC
## Automated Follow-Up Sequence for Netlify Form Submissions

---

## Email 1: Immediate Response (Auto-Reply)
**Subject:** Thank You for Contacting Tillerstead — Licensed NJ Tile & Remodeling Experts

**Body:**
```
Hi [Name],

Thank you for reaching out to Tillerstead LLC regarding your [Project Type] in [County/City]. As a fully licensed NJ Home Improvement Contractor (HIC #13VH10808800), we operate to TCNA and ANSI standards for every project.

**What to Expect Next:**
1. **Detailed Review:** Your project details are being reviewed by a TCNA-trained specialist. Expect a response within 24 hours (often much sooner).
2. **Personal Follow-Up:** We’ll contact you by [phone/email] to clarify your timeline, answer technical questions, and confirm project requirements.
3. **Comprehensive Estimate:** You’ll receive a written proposal outlining scope, materials (with ANSI/TCNA references), timeline, warranty, and payment terms.

**Need Immediate Assistance?**
- 📱 Text project photos to (609) 862-8808 for a 2–4 hour quote turnaround.
- 📞 Call us directly: (609) 862-8808
- 🚨 For urgent water damage or safety issues, call now—licensed for emergency repairs.

**Explore Our Expertise:**
- View our [portfolio](/portfolio/) of code-compliant South Jersey projects.
- Read [verified reviews](/reviews/) from Atlantic, Ocean & Cape May County clients.
- Download our [Free NJ Tile Installation Guide](/download/nj-tile-guide/)—includes TCNA/NJ HIC compliance checklists.

Thank you for considering Tillerstead—where technical precision and transparency set us apart.

Tyler  
Tillerstead LLC  
Licensed NJ Home Improvement Contractor  
HIC #13VH10808800  
(609) 862-8808  
tillerstead.com
```

---

## Email 2: Day 3 Follow-Up (If No Response)
**Subject:** Still Planning Your [Project Type]? TCNA-Compliant Guidance Awaits

**Body:**
```
Hi [Name],

Following up on your [Date] inquiry about [Project Type] in [County]. Choosing a contractor is a big decision—Tillerstead is here to answer your technical and compliance questions.

**Common Questions We Address:**
- What’s a realistic, code-compliant timeline for my project?
- Which tile and waterproofing systems meet ANSI A118.10 and TCNA standards?
- How do we ensure proper permits and NJ HIC compliance?
- Can we accommodate your schedule and accessibility needs?
- Are financing and written warranties available?

**Ready for a Detailed Estimate?**
Reply to this email, text/call (609) 862-8808, or [schedule a consultation](https://tillerstead.com/contact/).

Best regards,  
Tyler  
Tillerstead LLC
```

---

## Email 3: Day 7 — Value Email
**Subject:** 5 Critical Tile Installation Facts Every NJ Homeowner Should Know

**Body:**
```
Hi [Name],

Whether you choose Tillerstead or another contractor, protect your investment by knowing these TCNA/NJ HIC essentials:

**1. NJ HIC Licensing Is Mandatory**  
Always verify licensing at njconsumeraffairs.gov. Only licensed contractors can pull permits and provide legal protection.

**2. Waterproofing Must Meet ANSI A118.10**  
Improper waterproofing causes costly damage. Insist on certified membranes (Schluter, RedGard, Hydroban) installed per manufacturer and TCNA guidelines.

**3. Written, Detailed Estimates Are Your Safeguard**  
All scope, materials, payment terms, and warranties should be documented—verbal quotes are a red flag.

**4. Change Orders Require Written Approval**  
Professional contractors document all changes before work proceeds, protecting both parties.

**5. Beware of Low Bids—They Often Mean Shortcuts**  
Lowest quotes usually skip critical prep or use substandard materials. Typical South Jersey bath tile: $3,500–$8,500, depending on scope and selections.

**Want the full checklist?** Download our [Free NJ Tile Installation Guide](/download/nj-tile-guide/)—25 pages of expert, code-compliant advice.

**Questions?** Call/text (609) 862-8808 for technical guidance.

Best,  
Tyler  
Tillerstead LLC
```

---

## Email 4: Day 14 — Final Check-In
**Subject:** Final Follow-Up: Still Considering Your [Project Type]?

**Body:**
```
Hi [Name],

This is my last follow-up regarding your [Project Type] inquiry. If you’ve chosen another path, no worries—your project’s success is what matters.

If you’re still evaluating options, I’m available to:
- Answer technical or code questions about tile/remodeling
- Provide ballpark pricing and material recommendations
- Share references from [County] clients
- Ensure all work meets TCNA and NJ HIC standards

**How to Reach Us:**
1. Reply to this email
2. Text/call: (609) 862-8808  
3. Schedule online: [tillerstead.com/contact](https://tillerstead.com/contact/)

Thank you for considering Tillerstead—where compliance, transparency, and technical excellence come standard.

Tyler  
Tillerstead LLC  
Licensed NJ HIC #13VH10808800
```

---

## Netlify Forms Integration Setup

Add to `netlify.toml` (ensure all keys and paths follow OUTPUT_RULES.md):

```toml
[build]
  publish = "_site"

[[plugins]]
  package = "@netlify/plugin-emails"

[plugins.inputs]
  email_templates = "email-templates/"

[build.environment]
  CONTACT_EMAIL = "info@tillerstead.com"

# Email notifications
[[notifications]]
  type = "email"
  event = "submission-created"
  form = "homepage-contact"
  subject = "New Contact Form Submission - {{ name }}"
  to = "info@tillerstead.com"

[[notifications]]
  type = "email"
  event = "submission-created"
  form = "tile-guide-download"
  subject = "New Guide Download - {{ name }}"
  to = "info@tillerstead.com"
```

---

## Implementation Notes

1. **Automated Responses:** Use Netlify Forms + Zapier/Make.com to trigger the compliant email sequence.
2. **Segmentation:** Tag leads by project type, county, and urgency for targeted follow-up.
3. **SMS Integration:** Forward high-urgency leads to SMS using Twilio for rapid response.
4. **CRM Sync:** Integrate with ActiveCampaign, Mailchimp, or ConvertKit for drip campaigns and compliance tracking.
5. **Analytics:** Monitor open/click rates and conversion by email; ensure all tracking is privacy-compliant.

**Recommended Tools:**
- Netlify Forms (form capture, accessible and standards-compliant)
- Zapier (automation, with error handling)
- ConvertKit or ActiveCampaign (drip, segmentation, compliance)
- Twilio (SMS, with opt-out support)

---

**All content and workflows above are reviewed for TCNA, ANSI, and NJ HIC compliance. For technical or legal questions, reference the `.ai/DOMAIN.md` and `.ai/COMPLIANCE.md` files.**

