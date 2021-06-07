import axiosbase from 'axios';
import qs from 'qs';

const axios = axiosbase.create({
  baseURL: '/',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': null,
  },
  responseType: 'json',
  paramsSerializer: (params) => qs.stringify(params, { arrayFormat: 'brackets' }),
});
export default axios;
