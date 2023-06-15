import Vue from "vue";
import VueRouter from "vue-router";

import AdminContentSettings from "./components/AdminContentSettings";

Vue.use(VueRouter);

import store from "./store";
import { router } from "./routes";

document.addEventListener("turbolinks:load", () => {
  const adminContentSettingsElement = document.getElementById(
    "admin-content-settings"
  );

  if (adminContentSettingsElement) {
    new Vue({
      router,
      store,
      el: adminContentSettingsElement,
      components: {
        AdminContentSettings,
      },

      mounted() {
        if (this.$refs.isSuperAdmin) {
          this.$store.commit(
            "setIsSuperAdmin",
            this.$refs.isSuperAdmin.dataset.superAdmin
          );
        }
      },
    });
  }
});
