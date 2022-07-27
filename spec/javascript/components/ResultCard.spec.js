// Module imports
import { shallowMount } from '@vue/test-utils'
import ResultCard from 'components/ResultCard'

describe('ResultCard Vue component', () => {
  const reload = window.location.reload;

  beforeAll(() => {
    Object.defineProperty(window, 'location', {
      value: { reload: jest.fn() }
    });
  });

  afterAll(() => {
    window.location.reload = reload;
  });  

  let wrapper;

  beforeEach(() => {
    wrapper = shallowMount(ResultCard, {
      attachToDocument: true,
      propsData: {
        cardId: 'team-1',
        cardImage: 'path/to/my/image.jpg',
        cardTitle:'My Cool Team',
        cardSubtitle:'Los Angeles, California, United States',
        cardContent:'Division: None assigned yet',
        name:'My Cool Team',
        coverImage:false,
        declined:false,
        full:false,
        showBadges: false,
        isOnTeam: false,
        isVirtual: false,
        linkText:'More Details >',
        linkPath:'/path/to/team/1',
        onTeamText:'',
        virtualText:'',
      },
    })
  })

  afterEach(() => {
    wrapper.destroy()
  })

  describe('props', () => {
    it('contains valid props', () => {
      expect(ResultCard.props).toEqual({
        cardId:       { type: String,  required: true },
        cardImage:    { type: String,  required: false },
        cardTitle:    { type: String,  required: false },
        cardSubtitle: { type: String,  required: false },
        cardContent:  { type: String,  required: false },
        name:         { type: String,  required: false },
        linkText:     { type: String,  required: false },
        linkPath:     { type: String,  required: false },
        onTeamText:   { type: String,  required: false },
        virtualText:  { type: String,  required: false },
        coverImage:   { type: Boolean, required: false },
        declined:     { type: Boolean, required: false },
        full:         { type: Boolean, required: false },
        showBadges:   { type: Boolean, required: false },
        isOnTeam:     { type: Boolean, required: false },
        isVirtual:    { type: Boolean, required: false },
      })
    })
  })

  describe('computed properties', () => {
    describe('imgPlaceholderId', () => {
      it('set placeHolder id correctly', () => {
        expect(wrapper.vm.imgPlaceholderId).toEqual('img-ph-team-1')
      })
    })
  })

  describe('component states', () => {
    it('card has a footer', () => {
      let ResultCardFooter = wrapper.find('.search-card-footer')
      expect(ResultCardFooter.exists()).toBe(true)
    })

    it('card link text', () => {
      let ResultCardFooter = wrapper.find('.search-card-footer')
      expect(ResultCardFooter.text()).toContain('More Details >')
    })

    it('team declined the invite', async () => {
      await wrapper.setProps({ declined: true })
      let ResultCardFooter = wrapper.find('.search-card-footer')
      expect(ResultCardFooter.text()).toContain('they declined')
    })

    it('team is full', async () => {
      await wrapper.setProps({ full: true })
      let ResultCardFooter = wrapper.find('.search-card-footer')
      expect(ResultCardFooter.exists()).toBe(true)
      expect(ResultCardFooter.text()).toContain('This team is currently full.')
    })
  })
})