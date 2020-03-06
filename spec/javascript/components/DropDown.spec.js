import { shallowMount } from '@vue/test-utils'

import DropDown from 'components/DropDown'
import Icon from 'components/Icon'
import ClickOutside from 'directives/click-outside'

require('canvas')

describe('DropDown Vue component', () => {
  let wrapper

  beforeEach(() => {
    wrapper = shallowMount(DropDown, {
      attachToDocument: true,
      propsData: {
        label: 'More Information',
      },
      slots: {
        default: `
          <div>
            <h6>Hello World</h6>
            <ul>
              <li><a href="/link-1">Link One</a></li>
              <li><a href="/link-2">Link Two</a></li>
            </ul>
          </div>
        `,
      },
    })
  })

  afterEach(() => {
    wrapper.destroy()
  })

  describe('directives', () => {
    it('contains valid directives', () => {
      expect(DropDown.directives).toEqual({
        'click-outside': ClickOutside,
      })
    })
  })

  describe('props', () => {
    it('contains valid props', () => {
      expect(DropDown.props).toEqual({
        label: {
          type: String,
          required: true,
        },
      })
    })
  })

  describe('data', () => {
    it('sets the correct initial state', () => {
      expect(DropDown.data()).toEqual({
        expanded: false,
      })
    })
  })

  describe('computed properties', () => {
    describe('caretTitle', () => {
      it('returns "Collapse" if expanded', () => {
        wrapper.setData({ expanded: true })

        expect(wrapper.vm.caretTitle).toEqual('Collapse')
      })

      it('returns "Expand" if collapsed', () => {
        wrapper.setData({ expanded: false })

        expect(wrapper.vm.caretTitle).toEqual('Expand')
      })
    })

    describe('caretIcon', () => {
      it('returns "caret-up" if expanded', () => {
        wrapper.setData({ expanded: true })

        expect(wrapper.vm.caretIcon).toEqual('caret-up')
      })

      it('returns "caret-down" if collapsed', () => {
        wrapper.setData({ expanded: false })

        expect(wrapper.vm.caretIcon).toEqual('caret-down')
      })
    })
  })

  describe('methods', () => {
    describe('collapseDropDown', () => {
      it('collapses the dropdown', () => {
        wrapper.setData({ expanded: true })

        wrapper.vm.collapseDropDown()

        expect(wrapper.vm.expanded).toBe(false)
      })
    })

    describe('toggleCollapse', () => {
      it('toggles the drop down open and closed', () => {
        wrapper.setData({ expanded: true })

        wrapper.vm.toggleCollapse()

        expect(wrapper.vm.expanded).toBe(false)

        wrapper.vm.toggleCollapse()

        expect(wrapper.vm.expanded).toBe(true)

        wrapper.vm.toggleCollapse()

        expect(wrapper.vm.expanded).toBe(false)
      })
    })
  })

  describe('DOM interactions', () => {
    it('contains a top-level .drop-down component', () => {
      expect(wrapper.classes('drop-down')).toBe(true)
    })

    it('contains a link that toggles the drop down open and closed', async () => {
      const toggleCollapseSpy = spyOn(wrapper.vm, 'toggleCollapse')
        .and.callThrough()
      const toggleLink = wrapper.find('a')
      const dropDownContent = wrapper.find('.drop-down__content')

      expect(toggleLink.exists()).toBe(true)
      expect(dropDownContent.exists()).toBe(true)

      expect(dropDownContent.isVisible()).toBe(false)
      expect(toggleCollapseSpy).not.toHaveBeenCalled()

      toggleLink.element.click()
      await wrapper.vm.$nextTick()

      expect(dropDownContent.isVisible()).toBe(true)
      expect(toggleCollapseSpy).toHaveBeenCalledTimes(1)

      toggleLink.element.click()
      await wrapper.vm.$nextTick()

      expect(dropDownContent.isVisible()).toBe(false)
      expect(toggleCollapseSpy).toHaveBeenCalledTimes(2)
    })

    it('contains a caret icon which changes based on expanded/collpased state', async () => {
      const caretIcon = wrapper.find(Icon)

      expect(caretIcon.exists()).toBe(true)

      wrapper.setData({ expanded: true })
      await wrapper.vm.$nextTick()

      expect(caretIcon.props('title')).toEqual('Collapse')
      expect(caretIcon.props('name')).toEqual('caret-up')
      expect(caretIcon.props('color')).toEqual('000000')
      expect(caretIcon.props('size')).toEqual(12)

      wrapper.setData({ expanded: false })
      await wrapper.vm.$nextTick()

      expect(caretIcon.props('title')).toEqual('Expand')
      expect(caretIcon.props('name')).toEqual('caret-down')
      expect(caretIcon.props('color')).toEqual('000000')
      expect(caretIcon.props('size')).toEqual(12)
    })

    it('uses the v-click-outside directive to collapse the drop down', async () => {
      const dropDownContent = wrapper.find('.drop-down__content')

      const divNode = document.createElement('div')
      const textNode = document.createTextNode('This is some text.')
      divNode.appendChild(textNode)
      document.body.appendChild(divNode)

      wrapper.setData({ expanded: true })
      await wrapper.vm.$nextTick()

      expect(dropDownContent.exists()).toBe(true)
      expect(dropDownContent.isVisible()).toBe(true)

      divNode.click()
      await wrapper.vm.$nextTick()

      expect(dropDownContent.isVisible()).toBe(false)

      divNode.remove()
    })
  })
})
