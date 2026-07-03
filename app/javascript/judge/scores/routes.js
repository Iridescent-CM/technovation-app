import VueRouter from "vue-router";

import OverviewSection from "./sections/OverviewSection";
import ProjectDetails from "./sections/ProjectDetails";
import IdeationSection from "./sections/IdeationSection";
import PitchSection from "./sections/PitchSection";
import DemoSection from "./sections/DemoSection";
import EntrepreneurshipSection from "./sections/EntrepreneurshipSection";
import ReviewScore from "./sections/ReviewScore";

export const routes = [
  { path: "/", redirect: { name: "overview" } },
  { path: "/overview", name: "overview", component: OverviewSection },
  {
    path: "/project-details",
    name: "project_details",
    component: ProjectDetails,
  },
  { path: "/ideation", name: "ideation", component: IdeationSection },
  { path: "/pitch", name: "pitch", component: PitchSection },
  { path: "/demo", name: "demo", component: DemoSection },
  {
    path: "/entrepreneurship",
    name: "entrepreneurship",
    component: EntrepreneurshipSection,
  },
  { path: "/review-score", name: "review-score", component: ReviewScore },
];

export const router = new VueRouter({
  routes,
});

router.afterEach(() => {
  document.getElementById("main-content").scrollIntoView();
});
