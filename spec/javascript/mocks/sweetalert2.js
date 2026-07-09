const swal = {
  fire: () => Promise.resolve({ isConfirmed: true, value: true }),
  mixin: () => swal,
  close: () => {},
  isVisible: () => false,
};

export default swal;
