import "core-js/stable";
import "regenerator-runtime/runtime";

import Vue from 'vue'
import TurbolinksAdapter from 'vue-turbolinks'

import '../config/axios'

Vue.use(TurbolinksAdapter)

import '../submissions/screenshots'