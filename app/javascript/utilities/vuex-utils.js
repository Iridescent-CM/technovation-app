export const digStateData = (state, key, property, conditionFunc) => {
  const data = state[key].data

  if (data) {
    const value = state[key].data[property]
    if (value) {
      if (!conditionFunc)
        return value

      return conditionFunc(value)
    } else {
      return undefined
    }
  } else {
    return undefined
  }
}

export const digStateAttributes  = (state, key, attribute, conditionFunc) => {
  const attributes = digStateData(state, key, 'attributes')

  if (attributes) {
    const value = attributes[attribute]
    if (!conditionFunc)
      return value

    return conditionFunc(value)
  } else {
    return undefined
  }
}