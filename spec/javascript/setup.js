import Vue from "vue";
import Vue2Filters from "vue2-filters";
import { vi } from "vitest";

Vue.use(Vue2Filters.default || Vue2Filters);
Vue.config.productionTip = false;
Vue.config.devtools = false;

process.env.DATES_DIVISION_CUTOFF_YEAR = "2026";
process.env.DATES_DIVISION_CUTOFF_MONTH = "8";
process.env.DATES_DIVISION_CUTOFF_DAY = "1";
process.env.BEGINNER_DIVISION_JUDGING_RUBRIC_URL = "https://example.com/beginner";
process.env.GENERAL_JUDGING_RUBRIC_URL = "https://example.com/general";
process.env.JUNIOR_DIVISION_JUDGING_RUBRIC_URL = "https://example.com/junior";
process.env.SENIOR_DIVISION_JUDGING_RUBRIC_URL = "https://example.com/senior";
process.env.JUDGE_MAXIMUM_NUMBER_OF_RECUSALS = "3";
process.env.HELP_EMAIL = "help@example.com";
process.env.HOST_DOMAIN = "example.com";

global.axios = {
  get: vi.fn(() => Promise.resolve({ data: {} })),
  post: vi.fn(() => Promise.resolve({ data: {} })),
  patch: vi.fn(() => Promise.resolve({ data: {}, status: 200 })),
};

window.axios = global.axios;

global.swal = vi.fn();
global.$ = vi.fn(() => ({
  ajax: vi.fn(),
}));

global.$.ajax = vi.fn();
