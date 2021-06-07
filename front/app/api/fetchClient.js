import axios from './base';

const baseUrl = 'http://localhost:3000';
const FetchClient = {
  async get(url) {
    let response;
    await axios
      .get(baseUrl + url)
      .then((res) => { response = res.data; })
      .catch((error) => {
        response = { status: 'ERROR', message: error };
      });
    return response;
  },
  async post(url, data) {
    let response;
    await axios
      .post(baseUrl + url, data)
      .then((res) => { response = res.data; })
      .catch((error) => {
        response = { status: 'ERROR', message: error };
      });
    return response;
  },
  async put(url, data) {
    let response;
    await axios
      .put(baseUrl + url, data)
      .then((res) => { response = res.data; })
      .catch((error) => {
        response = { status: 'ERROR', message: error };
      });
    return response;
  },
  async delete(url) {
    let response;
    await axios
      .delete(baseUrl + url)
      .then((res) => { response = res.data; })
      .catch((error) => {
        response = { status: 'ERROR', message: error };
      });
    return response;
  },
};
export default FetchClient;
