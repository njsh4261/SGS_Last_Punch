export default function clearSession(reload = true) {
  sessionStorage.clear();
  if (reload) window.location.reload();
}
