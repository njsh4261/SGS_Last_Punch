export default function isEmail(email: string) {
  const reg = new RegExp(
    '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}',
    'i',
  );
  return reg.test(email);
}
