import { mount } from "@vue/test-utils";

export const formulateInputStub = {
  props: ["name", "id", "type", "label", "validation", "options"],
  template: `
    <div>
      <label>{{ label }}</label>
      <input
        v-if="type !== 'checkbox' && type !== 'select'"
        :id="id || name"
        :name="name"
        :type="type || 'text'"
        @input="$emit('input', $event.target.value)"
        @keyup="$emit('keyup', $event)"
        @blur="$emit('blur', $event)"
        @change="$emit('change', $event)"
      />
      <input
        v-else-if="type === 'checkbox' && (!options || !options.length)"
        :id="id || name"
        :name="name"
        type="checkbox"
        @change="$emit('input', $event.target.checked)"
        @keyup="$emit('keyup', $event)"
        @blur="$emit('blur', $event)"
      />
      <div v-else-if="type === 'checkbox'">
        <label
          v-for="option in options"
          :key="option.value"
          class="checkbox-option"
        >
          <input
            :name="name"
            type="checkbox"
            :value="option.value"
            @change="$emit('input', $event.target.checked)"
          />
          {{ option.label }}
        </label>
      </div>
      <select
        v-else
        :id="id || name"
        :name="name"
        @change="$emit('input', $event.target.value)"
        @keyup="$emit('keyup', $event)"
        @blur="$emit('blur', $event)"
      >
        <option value="">Select an option</option>
        <option v-for="option in options || []" :key="option" :value="option">
          {{ option }}
        </option>
      </select>
    </div>
  `,
};

export function mountWithAttachTo(component, options = {}) {
  const attachTo = document.createElement("div");
  document.body.appendChild(attachTo);

  const wrapper = mount(component, {
    attachTo,
    ...options,
  });

  return { wrapper, attachTo };
}
