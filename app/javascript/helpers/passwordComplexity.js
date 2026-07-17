export function passwordMeetsComplexity(password, email = "") {
  if (!password || password.length < 8) {
    return false;
  }

  if (!/[A-Z]/.test(password)) {
    return false;
  }

  if (!/[a-z]/.test(password)) {
    return false;
  }

  if (!/\d/.test(password)) {
    return false;
  }

  const localPart = email.split("@")[0]?.toLowerCase();
  if (localPart && password.toLowerCase().includes(localPart)) {
    return false;
  }

  return true;
}
