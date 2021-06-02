import axiosbase from 'axios';
import qs from 'qs';

export const axios = axiosbase.create({
  baseURL: '/',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRF-Token': null
  },
  responseType: 'json',
  paramsSerializer: (params) => {
    return qs.stringify(params, { arrayFormat: 'brackets' })
  }
});
