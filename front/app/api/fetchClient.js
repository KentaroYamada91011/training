import { axios } from '../api/base';

const FetchClient = {
  async get(url) {
    let response;
    await axios
      .get("http://localhost:3000" + url)
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
      .post("http://localhost:3000" + url, data)
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
      .put("http://localhost:3000" + url, data)
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
      .delete("http://localhost:3000" + url)
      .then(res => response = res.data)
      .catch((error) => {
        console.log(error);
        response = {status: "error"}
      });
    return response;
  },
};
export default FetchClient;
