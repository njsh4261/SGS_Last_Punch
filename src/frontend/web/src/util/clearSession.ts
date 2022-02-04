export default function clearSession(reload = true) {
  sessionStorage.clear();
  localStorage.clear();
  if (reload) window.location.reload();
}
