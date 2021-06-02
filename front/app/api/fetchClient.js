import { axios } from '../api/base';

const base_url = "http://localhost:3000"
const FetchClient = {  
  async get(url) {
    let response;
    await axios
      .get(base_url + url)
      .then(res => response = res.data)
      .catch((error) => {
          console.log(error);
          response = {status: "error"}
        });
    return response;
  },
  async post(url, data) {
    let response;
    await axios
      .post(base_url + url, data)
      .then(res => response = res.data)
      .catch((error) => {
        console.log(error);
        response = {status: "error"}
      });
    return response;
  },
  async put(url, data) {
    let response;
    console.log(data)
    await axios
      .put(base_url + url, data)
      .then(res => response = res.data)
      .catch((error) => {
        console.log(error);
        response = {status: "error"}
      });
    return response;
  },
  async delete(url) {
    let response;
    await axios
      .delete(base_url + url)
      .then(res => response = res.data)
      .catch((error) => {
        console.log(error);
        response = {status: "error"}
      });
    return response;
  },
};
export default FetchClient;
