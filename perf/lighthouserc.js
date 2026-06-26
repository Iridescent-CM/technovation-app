const BASE = process.env.PERF_BASE_URL || "http://localhost:3000"

const ROLE_URLS = {
  public: ["/", "/signup"],
  student: ["/student/team_submission_overview"],
  mentor: ["/mentor/dashboard"],
  judge: process.env.PERF_ENVIRONMENT === "qa"
    ? ["/chapterable_account_assignments/new"]
    : ["/judge/dashboard"],
  chapter_ambassador: ["/chapter_ambassador/dashboard"],
  admin: ["/admin/participants"]
}

const role = process.env.PERF_ROLE || "public"
const urls = ROLE_URLS[role]

if (!urls) {
  throw new Error(
    `Unknown PERF_ROLE "${role}". Expected one of: ${Object.keys(ROLE_URLS).join(", ")}`
  )
}

module.exports = {
  ci: {
    collect: {
      numberOfRuns: 5,
      url: urls.map((path) => `${BASE}${path}`),
      settings: {
        preset: "desktop",
        throttlingMethod: "simulate",
        onlyCategories: ["performance"],
        extraHeaders: JSON.stringify({
          Cookie: process.env.LH_AUTH_COOKIE || ""
        })
      }
    },
    assert: {
      assertions: {
        "categories:performance": ["warn", { minScore: 0.8 }],
        "largest-contentful-paint": ["warn", { maxNumericValue: 2500 }],
        "total-blocking-time": ["warn", { maxNumericValue: 200 }],
        "cumulative-layout-shift": ["warn", { maxNumericValue: 0.1 }]
      }
    },
    upload: {
      target: "filesystem",
      outputDir: process.env.LHCI_OUTPUT_DIR || "./tmp/lhci"
    }
  }
}
