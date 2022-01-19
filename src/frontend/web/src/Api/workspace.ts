import axios from 'axios';

// todo: remove userId and set Token
export async function getList(userId: string) {
  const host = process.env.REACT_APP_BACKEND_HOST;
  const endpoint = `/workspace/?userId=${userId}`;

  try {
    const response = await axios.get(host + endpoint);
    if (response.status !== 200) throw new Error('signup fail');
    return response.data.data;
  } catch (e) {
    return false;
  }
}
