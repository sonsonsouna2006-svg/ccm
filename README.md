# CCM Shipping Agency

A working English/Arabic shipping platform built with CCM's supplied logo, profile and selling-rate workbook. The first publication is private to its owner. It is not yet connected to `ccmshipping.com` or publicly indexed.

## Start using it

1. Open the secure one-time admin setup link supplied in chat. Choose your own name, email and password (12 or more characters).
2. Use `/admin/login` for the CCM team and `/login` for customers. Admins and customers have separate sign-in entry points and server-enforced roles.
3. In Website settings, edit the logos, contact details, social links, headings, service descriptions, footer and navigation. WhatsApp, Facebook and Instagram stay hidden until supplied.
4. Shipping rates can be added, edited, disabled, deleted or imported from `.xlsx`. Import previews show the rows before you confirm. Only the `selling` column is used. The workbook currency was confirmed as USD.
5. Review Commercial Register and Tax Card uploads in Verifications. Approve or reject them with a reason. A volume of 30+ containers is visible to staff as a Priority Lead.
6. Open a booking request to review its cargo details and confirm or decline it. Create a shipment and record its milestones manually.
7. Publish English/Arabic articles from Blog articles.

## Included data

- Origin: Sokhna Port, Egypt only.
- Aqaba: 20ft USD 500, 40ft USD 800.
- Jeddah: 20ft USD 500, 40ft USD 800.
- Mundra and Nhava Sheva: 20ft USD 480. No 40ft rate was supplied.
- Karachi: 20ft USD 400, 40ft USD 600.
- Both 40ft Dry and High Cube use the 40ft rate.
- Other supported destinations and all LCL shipments show a rate on request.
- No fake customers, shipments, reviews, certifications, carriers, transit times or expiry dates are seeded.

## Editing the source

| What to edit | File |
| --- | --- |
| Header, footer, logo, shared form controls | `components/ccm/Shared.tsx` |
| Homepage and public page content | `components/ccm/PublicClient.tsx` |
| Booking search, rate results and tracking | `components/ccm/SearchBox.tsx` |
| Registration, verification and booking forms | `components/ccm/AccountForms.tsx` |
| Customer/admin dashboards and settings | `components/ccm/Dashboard.tsx` |
| Initial company settings and supported ports | `lib/data.ts` |
| Excel import and route-name normalization | `lib/excel.ts` |
| Backend endpoints and role checks | `app/api/[...path]/route.ts` |
| Sessions, password hashing and database helper | `lib/server.ts` |
| Database schema | `db/schema.ts` |
| Database migrations | `drizzle/` |
| Visual styling and responsive/RTL rules | `app/globals.css` |
| Page routing and SEO metadata | `app/[...slug]/page.tsx`, `app/layout.tsx` |

Website settings are persistent database values. Changes to `lib/data.ts` affect a new database, not existing saved settings. Use the dashboard to update the live site.

## Runtime and security

D1 stores accounts, companies, rates, history, bookings, shipments, settings and articles. Private R2 objects hold verification files. The document endpoint checks ownership or staff permissions on every request, serves downloads with no-store caching, and never exposes a bucket URL.

Passwords are salted and hashed using PBKDF2-SHA512 (100,000 iterations, 512-bit output). Sessions use random tokens whose hashes are stored in D1, HttpOnly/SameSite cookies, HTTPS Secure cookies, expiry and server-side logout. Customer sessions last 30 days; staff sessions 12 hours. Requests use prepared SQL, origin checks and throttling. Uploads validate size and file signatures. Password changes revoke other sessions. Booking requests recheck verification, route availability and the current rate and use an idempotency key.

The app-owned email/password flow implements the user's explicit account requirements. Sites separately restricts access to the private publication. Before inviting public customers, the owner must choose public access and connect their domain. Publishing privately does not enable public SEO indexing.

`ADMIN_SETUP_TOKEN` is a secret configured in Sites, never embedded in frontend code or committed source. Admin setup is atomic and one-use. There are no hard-coded admin passwords. To recover an unused setup link, rotate that secret and issue a new link. Do not expose it in logs or public content.

Anonymous search allowance is tied to an HttpOnly browser cookie plus a database record. Clearing cookies or using another browser creates a new visitor. It is a lead-generation gate, not a verified-person quota.

There is no vessel tracking API, email delivery provider, or customer password reset email integration. Tracking is explicitly manual. Contact enquiries and booking requests appear in the dashboard; they are not sent by email. Blog entries remain empty until CCM publishes real content. Two route landing pages are provided (Jeddah and Jebel Ali); new route pages should have distinct, verified copy.

## Local development and validation

Use the project's pnpm lockfile. Follow Sites setup/build guidance for the active execution environment. Generate schema migrations with `pnpm db:generate`; retain applied migrations unchanged. Runtime seeding uses the supplied reference values once.

`node scripts/qa/integration.mjs` runs isolated Worker/D1/R2 integration checks after building. It creates test-only data in temporary storage and does not touch the published site. It covers free-search limits, exact rates, customer/staff access, admin setup, document validation/privacy, manual verification, booking idempotency/rate changes, tracking and article publication.

The optional WebMCP tool configures the visible search form without executing a search. It feature-detects browser support. WebMCP was unavailable in the browser used for verification.
