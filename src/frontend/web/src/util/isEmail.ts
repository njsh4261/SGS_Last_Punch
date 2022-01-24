export default function isEmail(email: string) {
  const reg = new RegExp(/[a-zA-Z0-9]*@[a-zA-Z0-9]*\.[a-zA-Z]/, 'i');
  return reg.test(email);
}
